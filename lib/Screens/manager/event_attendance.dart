import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group_event.dart';
import 'package:jerias_math/Model/student_attendance.dart';
import 'package:jerias_math/api/django_server_api.dart';

class EventStudentAttendanceListPage extends StatelessWidget {
  final GroupEvent? groupEvent;

  const EventStudentAttendanceListPage(this.groupEvent, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        //    title: Text(LocaleKeys.AlbertName.tr()),
      ),
      body: FutureBuilder<List<StudentAttendance?>?>(
        future: Repository().getEventStudentsAttanceAPI(groupEvent!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (snapshot.hasData) {
            List<StudentAttendance?> studentAttendanceList = snapshot.data!;

            return ListView.builder(
              itemCount: studentAttendanceList.length,
              itemBuilder: (context, index) {
                // Get the current student attendance object
                StudentAttendance? studentAttendance =
                    studentAttendanceList[index];

                return Card(
                  elevation: 2.0,
                  margin: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: ListTile(
                    title: Text(
                        ' ${studentAttendance?.student.firstName ?? ""} ${studentAttendance?.student.lastName ?? ""}'),
                    subtitle: Text(
                        'Status: ${getStatusText(studentAttendance?.status ?? 0)}'),
                    onTap: () {
                      // Handle onTap event
                    },
                  ),
                );
              },
            );
          } else {
            return const Center(
              child: Text('No data available'),
            );
          }
        },
      ),
    );
  }

  String getStatusText(int status) {
    // Implement your logic to convert status code to text
    // For example:
    if (status == 1) {
      return 'Attended';
    } else if (status == 0) {
      return 'Did Not Attend';
    } else if (status == 2) {
      return 'Free';
    } else {
      return 'Unknown';
    }
  }
}
