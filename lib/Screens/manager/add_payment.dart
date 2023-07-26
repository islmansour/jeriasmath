import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:jerias_math/Model/payment.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/api/django_server_api.dart';

class AddPaymentPage extends StatefulWidget {
  final Purchase purchase;
  final Person student;

  AddPaymentPage({super.key, required this.purchase, required this.student});

  @override
  // ignore: library_private_types_in_public_api
  _AddPaymentPageState createState() => _AddPaymentPageState();
}

class _AddPaymentPageState extends State<AddPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  Payment _payment = Payment(
    paymentType: 0,
  );
  int _currentStep = 0;

  @override
  void initState() {
    super.initState();
    _formKey.currentState;
  }

  DateTime? chequeDate;

  void handleDateSelected(DateTime? date) {
    setState(() {
      chequeDate = date;
    });
  }

  @override
  Widget build(BuildContext context) {
    _payment.purchase = widget.purchase;
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Payment'),
      ),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: _onStepContinue,
        onStepCancel: _onStepCancel,
        onStepTapped: _onStepTapped,
        steps: _stepperSteps(),
      ),
    );
  }

  List<Step> _stepperSteps() {
    return [
      Step(
        title: Text('Payment Type'),
        content: Form(
          key:
              _formKey, // Add the Form widget here and associate it with the _formKey
          child: Column(
            children: [
              RadioListTile<int>(
                title: Text('Cash'),
                value: 0,
                groupValue: _payment.paymentType,
                onChanged: (value) => _onPaymentTypeChanged(value),
              ),
              RadioListTile<int>(
                title: Text('Credit Card'),
                value: 1,
                groupValue: _payment.paymentType,
                onChanged: (value) => _onPaymentTypeChanged(value),
              ),
              RadioListTile<int>(
                title: Text('Cheque'),
                value: 2,
                groupValue: _payment.paymentType,
                onChanged: (value) => _onPaymentTypeChanged(value),
              ),
            ],
          ),
        ),
        isActive: _currentStep >= 0,
        state: _currentStep == 0 ? StepState.editing : StepState.complete,
      ),
      Step(
        title: Text('Cheque Details'),
        content: Column(
          children: [
            // Usage of CustomDatePicker widget
            CustomDatePicker(
              onDateSelected: handleDateSelected,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Cheque Number'),
              onChanged: (value) => _payment.chequeNumber = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Cheque Bank'),
              onChanged: (value) => _payment.chequeBranch = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Cheque Bank'),
              onChanged: (value) => _payment.chequeBank = value,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the payment amount';
                }
                return null;
              },
              onChanged: (value) => _payment.amount = double.parse(value),
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Notes'),
              onChanged: (value) => _payment.notes = value,
            ),
            // Add other cheque fields as needed
          ],
        ),
        isActive: _currentStep >= 1,
        state: _currentStep == 1 ? StepState.editing : StepState.disabled,
      ),
    ];
  }

  void _onStepContinue() {
    setState(() {
      if (_currentStep < _stepperSteps().length - 1) {
        _currentStep += 1;
      } else {
        _submitPayment();
      }
    });
  }

  void _onStepCancel() {
    setState(() {
      _currentStep = _currentStep > 0 ? _currentStep - 1 : _currentStep;
    });
  }

  void _onStepTapped(int step) {
    setState(() {
      _currentStep = step;
    });
  }

  void _onPaymentTypeChanged(int? value) {
    setState(() {
      _payment.paymentType = value;
      if (value == 2) {
        // If the payment type is 'Cheque', go to the Cheque Details step
        _currentStep = 1;
      } else {
        // Otherwise, go back to the Payment Type step
        _currentStep = 0;
      }
    });
  }

  // Function to submit the payment data to your backend
  Future<void> _submitPayment() async {
    // if (_formKey.currentState!.validate()) {
    // Repository().pa _payment.toJson();
    // }
    Repository().createPaymentAPI(_payment);
  }
}

class CustomDatePicker extends StatefulWidget {
  final Function(DateTime?) onDateSelected;

  const CustomDatePicker({super.key, required this.onDateSelected});

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final format = DateFormat("dd-MMMM-yyyy");
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });

      // Call the callback function with the selected date
      widget.onDateSelected(selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: TextFormField(
        decoration: InputDecoration(labelText: 'Custom Date Picker'),
        readOnly: true,
        controller: TextEditingController(
          text: selectedDate != null ? format.format(selectedDate!) : '',
        ),
      ),
    );
  }
}
