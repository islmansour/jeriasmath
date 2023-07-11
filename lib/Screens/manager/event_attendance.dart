import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group_event.dart';
import 'package:jerias_math/Model/student_attendance.dart';
import 'package:jerias_math/api/django_server_api.dart';

class EventStudentAttendanceListPage extends StatefulWidget {
  final GroupEvent? groupEvent;

  const EventStudentAttendanceListPage(this.groupEvent, {super.key});

  @override
  State<EventStudentAttendanceListPage> createState() =>
      _EventStudentAttendanceListPageState();
}

class _EventStudentAttendanceListPageState
    extends State<EventStudentAttendanceListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        //    title: Text(LocaleKeys.AlbertName.tr()),
      ),
      body: FutureBuilder<List<StudentAttendance?>?>(
        future: Repository().getEventStudentsAttanceAPI(widget.groupEvent!),
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
                    leading:
                        _buildAttendanceIcon(studentAttendance?.status ?? 0),
                    title: Text(
                      '${studentAttendance?.student.firstName ?? ""} ${studentAttendance?.student.lastName ?? ""}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Status: ${getStatusText(studentAttendance?.status ?? 0)}',
                    ),
                    //trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      setState(() {
                        studentAttendance?.status =
                            (studentAttendance.status + 1) % 3;
                        Repository()
                            .addStudentsAttanceAPI(studentAttendance!.toJson());
                      });
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

  Widget _buildAttendanceIcon(int status) {
    IconData iconData;
    Color iconColor;

    switch (status) {
      case 0:
        iconData = Icons.close;
        iconColor = Colors.red;
        break;
      case 1:
        iconData = Icons.check;
        iconColor = Colors.green;
        break;
      case 2:
        iconData = Icons.info;
        iconColor = Colors.blue;
        break;
      default:
        iconData = Icons.error;
        iconColor = Colors.grey;
    }

    return Icon(
      iconData,
      color: iconColor,
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
