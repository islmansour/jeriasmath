import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/group_event.dart';
import 'package:jerias_math/Screens/manager/event_attendance.dart';

class GroupEventCard extends StatelessWidget {
  final GroupEvent groupEvent;
  final Group? group;

  const GroupEventCard(this.groupEvent, {super.key, this.group});

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.yellow.shade700.withOpacity(0.4),
      elevation: 2.0,
      child: ListTile(
        title: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('EEEE').format(groupEvent.created!),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('dd/MM/yy').format(groupEvent.created!),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(groupEvent.created!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // subtitle: Text(
        //     'Status: ${getStatusText(studentAttendance?.status ?? 0)}'),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    EventStudentAttendanceListPage(groupEvent, group: group)),
          );
        },
      ),
    );
  }
}
