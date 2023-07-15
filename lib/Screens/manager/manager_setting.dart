import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Screens/manager/groups_list.dart';
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
        children: [
          const SizedBox(height: 80),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomButton(
                title: LocaleKeys.groups.tr(),
                onPressed: () {
                  GroupsClick(context: context);
                },
              ),
              CustomButton(title: LocaleKeys.students.tr(), onPressed: () {}),
              CustomButton(title: LocaleKeys.teachers.tr(), onPressed: () {}),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  const CustomButton({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onPressed,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupPage(),
          ),
        );
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.green,
        ),
        child: Center(
          child: Text(
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
