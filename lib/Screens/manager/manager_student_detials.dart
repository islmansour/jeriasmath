import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Screens/manager/edit_student.dart';
import 'package:jerias_math/Screens/manager/student_attendances_list.dart';
import 'package:jerias_math/Screens/manager/student_purchases_list.dart';

import 'package:jerias_math/l10n/locale_keys.g.dart';

class StudentDetailsPages extends StatefulWidget {
  final Person? student;

  const StudentDetailsPages({super.key, required this.student});

  @override
  State<StudentDetailsPages> createState() => _StudentDetailsPagesState();
}

class _StudentDetailsPagesState extends State<StudentDetailsPages> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title:
              Text('${widget.student!.firstName!} ${widget.student!.lastName}'),
          bottom: TabBar(
            tabs: [
              Tab(text: LocaleKeys.purchases.tr()),
              Tab(
                text: LocaleKeys.meetings.tr(),
              ),
              Tab(
                text: LocaleKeys.edit.tr(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            StudentPurchasesList(student: widget.student),
            StudentAttendancesList(student: widget.student),
            EditStudentFormPage(
              student: widget.student,
              editMode: true,
            ),
          ],
        ),
      ),
    );
  }
}
