import 'dart:core';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/main.dart';
import 'package:jerias_math/weekdays.dart';

List<String> weekDays = [];
int currentStep = 0;
List<Step> steps = [];

class GroupEditPage extends StatefulWidget {
  final Group? group;

  const GroupEditPage({super.key, required this.group});

  @override
  _GroupEditPageState createState() => _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  late Group _group;
  late TextEditingController _nameController;
  //late TextEditingController _typeController;
  List<DropdownMenuItem<String>> teacherDropdown = [];
  String? _selectedTeacherId;
  DateTime? _currentDate;
  int currentStep = 0;
  List<String> englishWeekdays = [];
  List<String> translatedWeekdays = [];
  List<String> weekdaysList = [];

  @override
  void initState() {
    String cleanedString = widget.group!.weekDays[0] == ']'
        ? widget.group!.weekDays.substring(1, widget.group!.weekDays.length - 1)
        : widget.group!.weekDays.substring(0, widget.group!.weekDays.length);

    // Step 2: Split the string using ", " as the delimiter
    weekdaysList = cleanedString.split(", ");

    // Step 3: Trim leading and trailing spaces from each element
    weekdaysList = weekdaysList.map((weekday) => weekday.trim()).toList();

    _currentDate =
        widget.group == null ? DateTime.now() : widget.group!.startDate;
    super.initState();
    teacherDropdown.clear();
    _group = widget.group!;
    _nameController = TextEditingController(text: _group.name);
    // _typeController = TextEditingController(text: _group.type.toString());
    _selectedTeacherId = _group.teacher?.id.toString();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    var userData = UserData.of(context);
    userData!.persons!.forEach((element) {
      if (element!.type == 1) {
        String teacherId = element.id.toString();
        teacherDropdown.add(DropdownMenuItem<String>(
          value: teacherId,
          child: Text('${element.firstName} ${element.lastName}'),
        ));
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    // _typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    steps = [
      Step(
        title: Text(LocaleKeys.groupDetails.tr()),
        content: Column(
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: LocaleKeys.name.tr()),
            ),
            DropdownButtonFormField<String>(
              value: _selectedTeacherId,
              onChanged: (value) {
                setState(() {
                  _selectedTeacherId = value;
                });
              },
              items: teacherDropdown,
              decoration: InputDecoration(labelText: LocaleKeys.teacher.tr()),
            ),
          ],
        ),
      ),
      Step(
        title: Text(LocaleKeys.dates.tr()),
        content: Column(
          children: [
            // TextFormField(
            //   onChanged: (value) {
            //     // Parse the input value to DateTime
            //     // and update the startDate variable.
            //   },
            //   decoration: InputDecoration(labelText: LocaleKeys.startDate.tr()),
            // ),
            // TextFormField(
            //   onChanged: (value) {
            //     // Parse the input value to DateTime
            //     // and update the endDate variable.
            //   },
            //   decoration: InputDecoration(labelText: LocaleKeys.endDate.tr()),
            // ),
            MultiSelect(
              titleText: LocaleKeys.learningDays.tr(),
              maxLength: 7, // optional
              validator: (dynamic value) {
                return value == null ? LocaleKeys.choose.tr() : null;
              },
              hintText: "",
              maxLengthText: "",
              selectedOptionsInfoText: "",
              initialValue: weekdaysList,
              cancelButtonText: LocaleKeys.cancel.tr(),
              saveButtonText: LocaleKeys.save.tr(),
              clearButtonText: LocaleKeys.clear.tr(),
              errorBorderColor: Colors.transparent,
              cancelButtonColor: Colors.white70,
              clearButtonColor: Colors.blue,
              dataSource: weekdays, // weekdays,
              textField: 'he',
              valueField: 'code',
              filterable: false,
              required: false,
              selectedOptionsBoxColor: Colors.transparent,
              buttonBarColor: Colors.transparent,
              selectIcon: Icons.arrow_drop_down_circle,
              onSaved: (value) {
                List<dynamic> dynamicList =
                    value as List<dynamic>; // Assuming value is a List<dynamic>
                List<String> stringList =
                    dynamicList.map((item) => item.toString()).toList();
                setState(() {
                  weekDays = stringList;
                });
              },
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      body: Stepper(
        currentStep: currentStep,
        onStepContinue: () {
          setState(() {
            if (currentStep < steps.length - 1) {
              currentStep += 1;
            } else {
              // _submitForm();
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
        steps: steps,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _group.name = _nameController.text;
          //_group.type = int.parse(_typeController.text);
          _group.teacher = _findTeacherById(_selectedTeacherId);
          widget.group!.startDate = _currentDate!;
          widget.group!.weekDays = weekDays.join(", ");
          Repository().upsertGroupsAPI(widget.group).then((value) {
            setState(() {
              //  userData!.upsertGroup!(widget.group);
            });

            Navigator.pop(context, true);
          });

          // Save the updated data here or perform any other actions
        },
        child: const Icon(Icons.save),
      ),
    );
  }

  Person? _findTeacherById(String? id) {
    var userData = UserData.of(context);
    if (id != null) {
      int teacherId = int.parse(id);
      return userData!.persons!.firstWhere((person) => person!.id == teacherId);
    }
    return null;
  }
}
