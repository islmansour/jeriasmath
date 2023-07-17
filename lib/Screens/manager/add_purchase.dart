import 'package:flutter/material.dart';
import 'package:jerias_math/Model/lookup_table.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/main.dart';

class CreatePurchasePage extends StatefulWidget {
  final Person student;

  const CreatePurchasePage({required this.student});

  @override
  _CreatePurchasePageState createState() => _CreatePurchasePageState();
}

class _CreatePurchasePageState extends State<CreatePurchasePage> {
  int currentStep = 0;
  Purchase purchase = Purchase();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  List<DropdownMenuItem<LookupTable>> purchaseStatusDropdown = [];
  List<LookupTable?>? lookupTableData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchLookupTableData();
  }

  Future<void> fetchLookupTableData() async {
    try {
      var userData = UserData.of(context);

      lookupTableData = await Repository().getLookupTableAPI();
      lookupTableData = lookupTableData!
          .where((element) => (element?.active == true &&
              element?.type == 'PURCHASE_STATUS' &&
              element!.lang == userData!.user.language))
          .toList();

      setState(() {
        purchaseStatusDropdown = lookupTableData!
            .map(
              (lookupTable) => DropdownMenuItem<LookupTable>(
                value: lookupTable,
                child: Text(lookupTable?.value ?? ''),
              ),
            )
            .toList();
      });
    } catch (e) {
      // Handle the error or show an error message
      print('Error fetching lookup table data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Purchase'),
      ),
      body: Stepper(
        currentStep: currentStep,
        onStepTapped: (step) {
          setState(() {
            currentStep = step;
          });
        },
        onStepContinue: () {
          final form = formKey.currentState;
          if (form != null && form.validate()) {
            form.save();
            if (currentStep < 1) {
              setState(() {
                currentStep += 1;
              });
            } else {
              createPurchaseForStudent();
            }
          }
        },
        onStepCancel: () {
          if (currentStep > 0) {
            setState(() {
              currentStep -= 1;
            });
          } else {
            Navigator.pop(context);
          }
        },
        steps: [
          Step(
            title: const Text('Step 1'),
            content: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Actual Payment',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      purchase.amount = double.parse(value!);
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Max Attendance',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Attendance is required';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      purchase.maxAttendances = int.parse(value!);
                    },
                  ),
                ],
              ),
            ),
            isActive: currentStep == 0,
          ),
          Step(
            title: const Text('Step 2'),
            content: Form(
              child: Column(
                children: [
                  DropdownButtonFormField<LookupTable>(
                    decoration: const InputDecoration(
                      labelText: 'Purchase Status',
                    ),
                    value: lookupTableData != null && purchase.status != null
                        ? lookupTableData!
                            .where(
                                (element) => element?.code == purchase.status)
                            .firstOrNull
                        : null,
                    items: purchaseStatusDropdown,
                    onChanged: (value) {
                      setState(() {
                        purchase.status = value!.code;
                      });
                    },
                    validator: (value) {
                      if (value == null) {
                        return 'Purchase status is required';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
            isActive: currentStep == 1,
          ),
        ],
      ),
    );
  }

  void createPurchaseForStudent() {
    var userData = UserData.of(context);
    purchase.student = widget.student;
    purchase.createdBy = userData!.user.person;
    purchase.lastUpdatedBy = userData!.user.person;

    Repository().addStudentsPurchaseAPI(purchase.toJson());
  }
}
