import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Screens/manager/group_details.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/weekdays.dart';

class GroupPage extends StatefulWidget {
  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
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
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await Navigator.pushNamed(context, '/add_group') == true) {
            setState(() {});
          }
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
            child: FutureBuilder<List<Group?>?>(
              future: Repository().getGroupsAPI(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Group?> groups = snapshot.data!;

                  return ListView.builder(
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      final payment = groups[index];
                      return GroupClassCard(group: payment!);
                    },
                  );
                } else {
                  return Center(
                      child: Text(
                    LocaleKeys.nodata.tr(),
                  ));
                }
              },
            ),
          ),
          // Expanded(
          //   child: ListView.builder(
          //     itemCount: groups!.length,
          //     itemBuilder: (BuildContext context, int index) {
          //       return GroupClassCard(group: groups[index]);
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}

class GroupClassCard extends StatefulWidget {
  final Group? group;

  const GroupClassCard({required this.group});

  @override
  State<GroupClassCard> createState() => _GroupClassCardState();
}

class _GroupClassCardState extends State<GroupClassCard> {
  @override
  Widget build(BuildContext context) {
    bool isActive = widget.group?.status == 1;

    return GestureDetector(
      onTap: () async {
        if (await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GroupDetailsPages(group: widget.group),
              ),
            ) ==
            true) setState(() {});
      },
      child: Card(
        shadowColor: Colors.yellow.shade700.withOpacity(0.4),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.green[200]!,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.groups_2_rounded,
                      color: Colors.green.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        widget.group?.name ?? '',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Icon(
                      isActive ? Icons.check_circle : Icons.cancel,
                      color: isActive ? Colors.green : Colors.red,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    flex: 6, // 7 parts out of 10 (70%)
                    child: IconWithContent(
                      iconData: Icons.calendar_today,
                      content: widget.group?.weekDays == "[]"
                          ? LocaleKeys.notSet.tr()
                          : widget.group?.weekDays
                                  .replaceAll('[', '')
                                  .replaceAll(']', '')
                                  .split(', ')
                                  .map((englishWeekday) =>
                                      translateWeekday(englishWeekday)
                                          .replaceAll('יום ', ''))
                                  .join(', ') ??
                              LocaleKeys.notSet.tr(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 3, // 3 parts out of 10 (30%)
                    child: IconWithContent(
                      iconData: Icons.co_present_outlined,
                      content: widget.group!.teacher == null
                          ? ''
                          : '${widget.group!.teacher!.firstName ?? ''} ${widget.group!.teacher!.lastName ?? ''}',
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

class IconWithContent extends StatelessWidget {
  final IconData iconData;
  final String content;

  const IconWithContent({
    Key? key,
    required this.iconData,
    required this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.green[200]!,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: Colors.green.shade700,
          ),
          const SizedBox(width: 8),
          Expanded(
            // Wrap the Text widget with Expanded
            child: Text(
              content,
              style: const TextStyle(fontSize: 12),
              overflow:
                  TextOverflow.ellipsis, // Add ellipsis to handle long text
            ),
          ),
        ],
      ),
    );
  }
}
