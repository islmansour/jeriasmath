import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/student_attendance.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';

class StudentAttendanceCard extends StatefulWidget {
  final StudentAttendance studentAttendance;

  const StudentAttendanceCard({super.key, required this.studentAttendance});

  @override
  _StudentAttendanceCardState createState() => _StudentAttendanceCardState();
}

class _StudentAttendanceCardState extends State<StudentAttendanceCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow.shade700.withOpacity(0.4),
      elevation: 2.0,
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAttendanceIcon(widget.studentAttendance.status),
            const SizedBox(
              height: 4,
            ),
            Text(
              getStatusText(widget.studentAttendance.status),
              style: const TextStyle(fontSize: 10, color: Colors.blueGrey),
            ),
          ],
        ),
        title: Text(
          '${DateFormat('dd/MM/yy').format(widget.studentAttendance.groupEvent!.created!)} ',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Row(
          children: [
            Expanded(
              flex:
                  7, // This will make the first Text take 70% of the available space
              child: Text(
                widget.studentAttendance.groupEvent!.group!.name,
                // getStatusText(widget.studentAttendance.status),
              ),
            ),
            Expanded(
              flex:
                  3, // This will make the second Text take 30% of the available space
              child: Text(
                '${widget.studentAttendance.groupEvent!.createdBy!.firstName.toString()} ${widget.studentAttendance.groupEvent!.createdBy!.lastName.toString()}',
                // getStatusText(widget.studentAttendance.status),
              ),
            ),
          ],
        ),
        onTap: () {
          setState(() {
            widget.studentAttendance.status =
                (widget.studentAttendance.status + 1) % 3;
            Repository()
                .addStudentsAttendanceAPI(widget.studentAttendance.toJson());
          });
        },
      ),
    );
  }
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
      iconData = Icons.recycling;
      iconColor = Colors.blue;
      break;
    default:
      iconData = Icons.error;
      iconColor = Colors.grey;
  }

  return CircleAvatar(
    backgroundColor: iconColor,
    child: Icon(
      iconData,
      color: Colors.white,
    ),
  );
}

String getStatusText(int status) {
  // Implement your logic to convert status code to text
  // For example:
  if (status == 1) {
    return LocaleKeys.attended.tr();
  } else if (status == 0) {
    return LocaleKeys.notAttended.tr();
  } else if (status == 2) {
    return LocaleKeys.free.tr();
  } else {
    return 'Unknown';
  }
}
