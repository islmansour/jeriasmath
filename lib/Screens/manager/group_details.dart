import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Screens/manager/edit_group.dart';
import 'package:jerias_math/Screens/manager/group_students_list.dart';
import 'package:jerias_math/Screens/manager/manager_group_events_list.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';

class GroupDetailsPages extends StatefulWidget {
  final Group? group;

  const GroupDetailsPages({super.key, required this.group});

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
              Tab(text: LocaleKeys.meetings.tr()),
              Tab(
                text: LocaleKeys.students.tr(),
              ),
              Tab(
                text: LocaleKeys.edit.tr(),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ManagerGroupEventList(group: widget.group),
            GroupPersonsList(group: widget.group),
            GroupEditPage(group: widget.group),
          ],
        ),
      ),
    );
  }
}
