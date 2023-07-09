import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Screens/manager/edit_group.dart';
import 'package:jerias_math/Screens/manager/group_students_list.dart';
import 'package:jerias_math/Screens/manager/manager_group_events_list.dart';

class GroupDetailsPages extends StatefulWidget {
  final Group? group;

  GroupDetailsPages({required this.group});

  @override
  State<GroupDetailsPages> createState() => _GroupDetailsPagesState();
}

class _GroupDetailsPagesState extends State<GroupDetailsPages> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.group!.name),
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Edit',
              ),
              Tab(text: 'Meetings'),
              Tab(
                text: 'Student',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            GroupEditPage(group: widget.group),
            ManagerGroupEventList(group: widget.group),
            GroupPersonsList(group: widget.group),
          ],
        ),
      ),
    );
  }
}
