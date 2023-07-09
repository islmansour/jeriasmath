import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';

final Map<String, dynamic> database = {
  'groups': [
    {
      "id": 1,
      "name": "Math Group",
      "teacherId": "T123",
      "startDate": "2023-07-01T09:00:00Z",
      "endDate": "2023-12-31T15:00:00Z",
      "weekDays": "Monday, Wednesday, Friday",
      "type": "Regular",
      "status": "Active",
      "time": "14:00:00"
    }
  ],
  'students': [],
  'teachers': [],
};

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
          const SizedBox(height: 10),
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
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // CustomButton(title: 'Button 4'),
              // CustomButton(title: 'Button 5'),
              // CustomButton(title: 'Button 6'),
            ],
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: 5, // Replace with the actual number of cards
              itemBuilder: (context, index) {
                return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text('Card ${index + 1}'),
                  ),
                );
              },
            ),
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
      onTap: onPressed,
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
