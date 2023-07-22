import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/main.dart';
import 'package:jerias_math/weekdays.dart';

class AddGroupPage extends StatefulWidget {
  const AddGroupPage({super.key});

  @override
  _AddGroupPageState createState() => _AddGroupPageState();
}

class _AddGroupPageState extends State<AddGroupPage> {
  int currentStep = 0;
  List<Step> steps = [];
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String groupName = '';
  int groupType = -1;
  Person? teacher;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  List<String> weekDays = [];

  List<DropdownMenuItem<Person>> teacherDropdown = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var userData = UserData.of(context);
    userData!.persons!.forEach(
      (element) {
        if (element!.type == 1) {
          teacherDropdown.add(DropdownMenuItem<Person>(
            value: element,
            child: Text('${element.firstName} ${element.lastName}'),
          ));
        }
      },
    );

    steps = [
      Step(
        title: Text(LocaleKeys.groupDetails.tr()),
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                onChanged: (value) {
                  groupName = value;
                },
                decoration: InputDecoration(labelText: LocaleKeys.name.tr()),
              ),
              TextFormField(
                onChanged: (value) {
                  groupType = int.parse(value);
                },
                decoration: InputDecoration(labelText: LocaleKeys.type.tr()),
              ),
              DropdownButtonFormField<Person>(
                value: teacher,
                onChanged: (value) {
                  setState(() {
                    teacher = value;
                  });
                },
                items: teacherDropdown,
                decoration: InputDecoration(labelText: LocaleKeys.teacher.tr()),
              ),
            ],
          ),
        ),
        isActive: true,
      ),
      Step(
        title: Text(LocaleKeys.dates.tr()),
        content: Column(
          children: [
            TextFormField(
              onChanged: (value) {
                // Parse the input value to DateTime
                // and update the startDate variable.
              },
              decoration: InputDecoration(labelText: LocaleKeys.startDate.tr()),
            ),
            TextFormField(
              onChanged: (value) {
                // Parse the input value to DateTime
                // and update the endDate variable.
              },
              decoration: InputDecoration(labelText: LocaleKeys.endDate.tr()),
            ),
            MultiSelect(
              titleText: LocaleKeys.learningDays.tr(),
              maxLength: 7, // optional
              validator: (dynamic value) {
                return value == null ? LocaleKeys.choose.tr() : null;
              },
              hintText: "",
              maxLengthText: "",
              selectedOptionsInfoText: "",
              cancelButtonText: LocaleKeys.cancel.tr(),
              saveButtonText: LocaleKeys.save.tr(),
              clearButtonText: LocaleKeys.clear.tr(),
              errorBorderColor: Colors.transparent,
              cancelButtonColor: Colors.white70,
              clearButtonColor: Colors.blue,
              dataSource: weekdays,
              textField: 'he',
              valueField: 'code',
              filterable: false,
              required: false,
              selectedOptionsBoxColor: Colors.transparent,
              buttonBarColor: Colors.transparent,
              selectIcon: Icons.arrow_drop_down_circle,
              onSaved: (value) {
                setState(() {
                  weekDays = value;
                });
              },
            ),
          ],
        ),
        isActive: false,
      ),
    ];
  }

  void _submitForm() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();

      final userData = UserData.of(context);

      Group tmp = (Group(
        1,
        groupType,
        endDate,
        groupName,
        startDate,
        teacher,
        -1,
        weekDays.toString(),
      ));
      userData!.setGroups!(tmp);
      Navigator.pop(context, true);
      // Navigator.pop(
      //   context,
      //   Group(
      //     1,
      //     groupType,
      //     endDate,
      //     groupName,
      //     startDate,
      //     teacher,
      //     -1,
      //     weekDays.toString(),
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.add.tr()),
      ),
      body: Container(
        alignment: Alignment.topRight,
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Stepper(
            currentStep: currentStep,
            steps: steps,
            onStepContinue: () {
              setState(() {
                if (currentStep < steps.length - 1) {
                  currentStep += 1;
                } else {
                  _submitForm();
                }
              });
            },
            onStepCancel: () {
              setState(() {
                if (currentStep > 0) {
                  currentStep -= 1;
                } else {
                  currentStep = 0;
                }
              });
            },
            onStepTapped: (step) {
              setState(() {
                currentStep = step;
              });
            },
          ),
        ),
      ),
    );
  }
}
