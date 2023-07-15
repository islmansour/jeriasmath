import 'dart:core';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/main.dart';

List<String> weekDays = [];
int currentStep = 0;
List<Step> steps = [];
DateTime? _currentDate;

class GroupEditPage extends StatefulWidget {
  final Group? group;

  GroupEditPage({required this.group});

  @override
  _GroupEditPageState createState() => _GroupEditPageState();
}

class _GroupEditPageState extends State<GroupEditPage> {
  late Group _group;
  late TextEditingController _nameController;
  late TextEditingController _typeController;
  List<DropdownMenuItem<String>> teacherDropdown = [];
  String? _selectedTeacherId;
  DateTime? _currentDate;
  int currentStep = 0;

  @override
  void initState() {
    _currentDate =
        widget.group == null ? DateTime.now() : widget.group!.startDate;
    super.initState();
    _group = widget.group!;
    _nameController = TextEditingController(text: _group.name);
    _typeController = TextEditingController(text: _group.type.toString());
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
    _typeController.dispose();
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
            TextFormField(
              controller: _typeController,
              decoration: InputDecoration(labelText: LocaleKeys.type.tr()),
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
            // Calendar and other form fields
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
          _group.type = int.parse(_typeController.text);
          _group.teacher = _findTeacherById(_selectedTeacherId);
          widget.group!.startDate = _currentDate!;

          final userData = UserData.of(context);
          setState(() {
            userData!.upsertGroup!(widget.group);
          });

          Repository().upsertGroupsAPI(widget.group).then((value) {
            setState(() {
              userData!.upsertGroup!(widget.group);
            });
          });

          // Save the updated data here or perform any other actions
          Navigator.pop(context);
        },
        child: Icon(Icons.save),
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
