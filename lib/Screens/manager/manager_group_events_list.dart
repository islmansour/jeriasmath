import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/group_event.dart';
import 'package:jerias_math/Screens/group_event_card.dart';
import 'package:jerias_math/Screens/manager/add_attendance.dart';
import 'package:jerias_math/api/django_server_api.dart';

class ManagerGroupEventList extends StatefulWidget {
  final Group? group;

  const ManagerGroupEventList({Key? key, required this.group})
      : super(key: key);

  @override
  State<ManagerGroupEventList> createState() => _ManagerGroupEventListState();
}

class _ManagerGroupEventListState extends State<ManagerGroupEventList> {
  List<GroupEvent?>? groupEvents = List.empty();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // ignore: unrelated_type_equality_checks
          if (await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAttendancePage(group: widget.group),
                ),
              ) ==
              true) setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<GroupEvent?>?>(
        future: Repository().getGroupEventsAPI(widget.group),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            final groupEvents = snapshot.data!;
            return ListView.builder(
              itemCount: groupEvents.length,
              itemBuilder: (context, index) {
                return GroupEventCard(groupEvents[index]!);
              },
            );
          }
        },
      ),
    );
  }
}
