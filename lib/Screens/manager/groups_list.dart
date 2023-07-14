import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Screens/manager/group_details.dart';
import 'package:jerias_math/main.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/weekdays.dart';

class GroupPage extends StatelessWidget {
  Widget _buildStep({required String title, required Widget content}) {
    return ExpansionTile(
      title: Text(title),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: content,
        ),
      ],
    );
  }

  // Rest of the code remains the same
  @override
  Widget build(BuildContext context) {
    final userData = UserData.of(context);
    final groups = userData!.groups;

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_group');
        },
        child: const Icon(Icons.add),
        // backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        title: Text(LocaleKeys.groups.tr()),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: groups!.length,
              itemBuilder: (BuildContext context, int index) {
                return GroupClassCard(group: groups[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class GroupClassCard extends StatelessWidget {
  final Group? group;

  const GroupClassCard({required this.group});

  @override
  Widget build(BuildContext context) {
    bool isActive = group?.status == 1;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupDetailsPages(group: group),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.group,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      group?.name ?? '',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Icon(
                    isActive ? Icons.check_circle : Icons.cancel,
                    color: isActive ? Colors.green.shade700 : Colors.red,
                  ),
                ],
              ),
              // const SizedBox(height: 4),
              // Row(
              //   children: [
              //     const Icon(
              //       Icons.co_present_outlined,
              //       color: Colors.green,
              //     ),
              //     const SizedBox(width: 8),
              //     Expanded(
              //       child: Text(
              //         group!.teacher == null
              //             ? ''
              //             : '${group!.teacher!.firstName ?? ''} ${group!.teacher!.lastName ?? ''}',
              //         style: const TextStyle(fontSize: 12),
              //       ),
              //     ),
              //   ],
              // ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: group?.weekDays == "[]"
                        ? Text(
                            LocaleKeys.notSet.tr(),
                            style: const TextStyle(fontSize: 12),
                          )
                        : Text(
                            group?.weekDays
                                    .replaceAll('[', '')
                                    .replaceAll(']', '')
                                    .split(', ')
                                    .map((englishWeekday) =>
                                        translateWeekday(englishWeekday)
                                            .replaceAll('יום ', ''))
                                    .join(', ') ??
                                LocaleKeys.notSet.tr(),
                            style: const TextStyle(fontSize: 12),
                          ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.co_present_outlined,
                    color: Colors.green,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      group!.teacher == null
                          ? ''
                          : '${group!.teacher!.firstName ?? ''} ${group!.teacher!.lastName ?? ''}',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
