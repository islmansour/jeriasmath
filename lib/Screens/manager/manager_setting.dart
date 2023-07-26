import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Screens/manager/students_list.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';

// ignore: must_be_immutable
class ManagerSettingsPage extends StatefulWidget {
  Map<String, dynamic>? db;
  ManagerSettingsPage({super.key, this.db});

  @override
  State<ManagerSettingsPage> createState() => _ManagerSettingsPageState();
}

class _ManagerSettingsPageState extends State<ManagerSettingsPage> {
  @override
  Widget build(BuildContext context) {
    //db ??= database;
    return Scaffold(
      appBar: AppBar(
        title: Text(LocaleKeys.management.tr()),
      ),
      body: Column(
        //   mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 24,
          ),
          CustomButtonCard(
            title: LocaleKeys.groups.tr(),
            buttonIcon: Icons.groups_2,
            onPressed: () {
              GroupsClick(context: context);
            },
          ),
          const SizedBox(
            height: 8,
          ),
          CustomButtonCard(
              title: LocaleKeys.students.tr(),
              buttonIcon: Icons.person,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const StudentsListPage(),
                  ),
                );
              }),
          const SizedBox(
            height: 8,
          ),
          CustomButtonCard(
            title: LocaleKeys.teachers.tr(),
            onPressed: () {},
            buttonIcon: Icons.co_present_outlined,
          ),
        ],
      ),
    );
  }
}

class CustomButtonCard extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final IconData buttonIcon;

  const CustomButtonCard(
      {Key? key,
      required this.title,
      required this.onPressed,
      required this.buttonIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              10), // Half of the width and height to make it a circle
        ),
        color: Colors.green,
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(
              buttonIcon,
              color: Colors.green,
            ),
          ),
          trailing: const Icon(
            Icons.arrow_circle_left_rounded,
            color: Colors.white,
          ),
          title: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

GroupsClick({VoidCallback? callback, BuildContext? context}) {
  callback?.call();
  Navigator.pushNamed(context!,
      '/groups'); // Check if the callback is not null before invoking it
}
