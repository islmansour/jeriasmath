import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/student_attendance.dart';
import 'package:jerias_math/Screens/student_attendance_card.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';

// ignore: must_be_immutable
class StudentAttendancesList extends StatefulWidget {
  Person? student;

  StudentAttendancesList({super.key, this.student});

  @override
  State<StudentAttendancesList> createState() => _StudentAttendancesListState();
}

class _StudentAttendancesListState extends State<StudentAttendancesList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<StudentAttendance?>?>(
        future: Repository().getStudentsAttendanceAPI(widget.student!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final studentAttendances = snapshot.data!;
            return ListView.builder(
              itemCount: studentAttendances.length,
              itemBuilder: (context, index) {
                final studentAttendance = studentAttendances[index];
                return StudentAttendanceCard(
                    studentAttendance: studentAttendance!);
              },
            );
          } else {
            return Center(child: Text(LocaleKeys.nodata.tr()));
          }
        },
      ),
    );
  }
}
