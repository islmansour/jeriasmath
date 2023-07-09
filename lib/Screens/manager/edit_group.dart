import 'dart:core';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:flutter_multiselect/flutter_multiselect.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/main.dart';
import 'package:jerias_math/weekdays.dart';

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
  late TextEditingController _teacherIdController;

  @override
  void initState() {
    _currentDate =
        widget.group == null ? DateTime.now() : widget.group!.startDate;

    final _calendarCarousel = CalendarCarousel<Event>(
      selectedDateTime: _currentDate,
      onDayPressed: (date, events) {
        this.setState(() => _currentDate = date);
        events.forEach((event) => print(event.title));
      },
      weekendTextStyle: const TextStyle(
        color: Colors.red,
      ),
      locale: "he",
      firstDayOfWeek: 0,
      thisMonthDayBorderColor: Colors.grey,
//          weekDays: null, /// for pass null when you do not want to render weekDays
      //headerText: 'Custom Header',
      weekFormat: true,
      height: 200.0,
      showIconBehindDayText: true,
//          daysHaveCircularBorder: false, /// null for not rendering any border, true for circular border, false for rectangular border
      customGridViewPhysics: const NeverScrollableScrollPhysics(),
      markedDateShowIcon: true,
      markedDateIconMaxShown: 2,
      selectedDayTextStyle: const TextStyle(
        color: Colors.yellow,
      ),
      todayTextStyle: const TextStyle(
        color: Colors.blue,
      ),
      markedDateIconBuilder: (event) {
        return event.icon ?? const Icon(Icons.help_outline);
      },
      minSelectedDate: _currentDate!.subtract(const Duration(days: 360)),
      maxSelectedDate: _currentDate!.add(const Duration(days: 360)),
      todayButtonColor: Colors.transparent,
      todayBorderColor: Colors.green,
      markedDateMoreShowTotal:
          true, // null for not showing hidden events indicator
//          markedDateIconMargin: 9,
//          markedDateIconOffset: 3,
    );
    super.initState();
    _group = widget.group!;
    _nameController = TextEditingController(text: _group.name);
    _typeController = TextEditingController(text: _group.type.toString());
    _teacherIdController =
        TextEditingController(text: _group.teacherId.toString());
    List<String> initWeekdays = widget.group!.weekDays
        .replaceAll("[", "")
        .replaceAll("]", "")
        .split(', ');

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
            TextFormField(
              controller: _teacherIdController,
              decoration: InputDecoration(labelText: LocaleKeys.teacher.tr()),
            ),
          ],
        ),
      ),
      Step(
        title: Text(LocaleKeys.dates.tr()),
        content: Column(
          children: [
            _calendarCarousel,
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
              initialValue: initWeekdays,
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
              // saveButtonColor: Theme.of(context).primaryColor,
              // checkBoxColor: Theme.of(context).primaryColorDark,
              // cancelButtonColor: Theme.of(context).primaryColorLight,
              //responsiveDialogSize: Size(600, 800),
              onSaved: (value) {
                setState(() {
                  if (value == null) {
                    weekDays = List.empty();
                  } else {
                    weekDays = value.cast<String>();
                  }
                  widget.group!.weekDays = weekDays.toString();
                });
              },
            ),
          ],
        ),
        isActive: false,
      ),
    ];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _typeController.dispose();
    _teacherIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          steps: steps),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _group.name = _nameController.text;
          _group.type = int.parse(_typeController.text);
          _group.teacherId = int.parse(_teacherIdController.text);
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
}
