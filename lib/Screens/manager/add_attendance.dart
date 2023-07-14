import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/group_event.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/person_group.dart';
import 'package:jerias_math/Model/student_attendance.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/l10n/locale_keys.g.dart';
import 'package:jerias_math/main.dart';

class CustomStudentCard extends StatefulWidget {
  final Person? student;
  final int studentIndex;

  const CustomStudentCard({
    Key? key,
    required this.student,
    required this.studentIndex,
  }) : super(key: key);

  @override
  _CustomStudentCardState createState() => _CustomStudentCardState();
}

class _CustomStudentCardState extends State<CustomStudentCard> {
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    final userData = UserData.of(context);
    return Card(
      elevation: 1.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            isChecked = !isChecked;
            if (isChecked) {
              attednaceResults.add(StudentAttendance(
                created: DateTime.now(),
                createdBy: userData!.user.person!.id!,
                id: -1,
                lastUpdated: DateTime.now(),
                lastUpdatedBy: userData.user.contactId!,
                status: 1,
                student: widget.student!,
              ));
            } else {
              attednaceResults.removeWhere(
                (element) => element!.student.id == widget.student!.id,
              );
            }
          });
        },
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.green,
            child: Text(
              '${widget.studentIndex}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            '${widget.student!.firstName} ${widget.student!.lastName}',
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          trailing: Checkbox(
            value: isChecked,
            onChanged: (value) {
              setState(() {
                isChecked = value ?? false;
                if (isChecked) {
                  attednaceResults.add(StudentAttendance(
                    created: DateTime.now(),
                    createdBy: userData!.user.person!.id!,
                    id: -1,
                    lastUpdated: DateTime.now(),
                    lastUpdatedBy: userData.user.contactId!,
                    status: 1,
                    student: widget.student!,
                  ));
                } else {
                  attednaceResults.removeWhere(
                    (element) => element!.student.id == widget.student!.id,
                  );
                }
              });
            },
          ),
        ),
      ),
    );
  }
}

List<GroupPerson?>? originalList;
List<StudentAttendance?> attednaceResults = [];

class AddAttendancePage extends StatefulWidget {
  final Group? group;

  const AddAttendancePage({Key? key, required this.group}) : super(key: key);

  @override
  _AddAttendancePageState createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  List<GroupPerson?> persons = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPersons(widget.group!.id);
    });

    attednaceResults = [];
  }

  void fetchPersons(int groupId) {
    final userData = UserData.of(context);

    if (userData != null && userData.groupPersons != null) {
      final List<GroupPerson?>? allPersons = userData.groupPersons;
      final List<GroupPerson?> persons =
          allPersons!.where((person) => person?.groupId == groupId).toList();
      setState(() {
        this.persons = persons;
        originalList = persons;
      });
    }
  }

  void addCustomGroupPerson(GroupPerson customGroupPerson) {
    setState(() {
      persons.add(customGroupPerson);
      final userData = UserData.of(context);
      userData!.addGroupPerson!(customGroupPerson);
    });
  }

  @override
  Widget build(BuildContext context) {
    final userData = UserData.of(context);
    final List<GroupPerson?>? allPersons = userData?.groupPersons;
    if (allPersons == null) {
      return Scaffold(
        body: Center(
          child: Text(LocaleKeys.nodata.tr()),
        ),
      );
    }
    final List<GroupPerson?> persons = allPersons
        .where((person) => person?.groupId == widget.group!.id)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Attendance1'),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addButton',
            onPressed: () {
              _showSearchDialog(context);
            },
            child: Icon(Icons.add),
          ),
          SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'saveButton',
            onPressed: () {
              userData!.setGroupPersons!(originalList);
              _createAttendanceRecord(context, persons);
              setState(() {});

              Navigator.pop(context, true);
            },
            child: Icon(Icons.save),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
          return CustomStudentCard(
            student: person!.student,
            studentIndex: index + 1,
          );
        },
      ),
    );
  }

  void _createAttendanceRecord(
      BuildContext contex, List<GroupPerson?>? students) {
    final userData = UserData.of(context);
    GroupEvent ge = GroupEvent(DateTime.now(), userData!.user.person!,
        widget.group, -1, DateTime.now(), userData.user.person!, 1);
    Repository().addGroupEventAPI(ge.toJson()).then((newGroupEvent) {
      // the attednaceResults now has all the people that attended the class,
      // in order to also set "not attended" to thoe who are not present. We go over the list
      // of students in the group, then check if they appear in attednaceResults, if yes we DO NOT DO
      // anything otherwise we add them to attednaceResults but status = 0 which means "not attended"
      students!.forEach((element) {
        bool found = false;
        attednaceResults.forEach((sa) {
          if (sa!.student.id == element!.student!.id) found = true;
        });
        if (!found) {
          attednaceResults.add(StudentAttendance(
              created: DateTime.now(),
              createdBy: userData.user.person!.id!,
              id: -1,
              lastUpdated: DateTime.now(),
              lastUpdatedBy: userData.user.person!.id!,
              status: 0,
              student: element!.student!));
        }
      });
      attednaceResults.forEach((sa) {
        sa!.setGroupEvent = newGroupEvent!;
        Repository().addStudentsAttanceAPI(sa.toJson());
      });
    });
    setState(() {});
  }

  void _showSearchDialog(BuildContext context) {
    TextEditingController _phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: 'Enter Student Phone',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final userData = UserData.of(context);
                    final _students = userData!.persons;
                    String enteredPhone = _phoneController.text;

                    var studentFound = _students!
                        .where((element) => element!.phone == enteredPhone)
                        .firstOrNull;

                    Navigator.pop(context);
                    _showResultDialog(context, studentFound);
                  },
                  child: Text('Search'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showResultDialog(BuildContext context, Person? studentFound) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (studentFound != null)
                  Text(
                    '${studentFound.firstName} ${studentFound.lastName}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 8),
                if (studentFound != null)
                  ElevatedButton(
                    onPressed: () {
                      final userData = UserData.of(context);
                      final currentUser = userData!.user;
                      GroupPerson customGroupPerson = GroupPerson(
                          DateTime.now(),
                          currentUser.contactId,
                          widget.group!.id,
                          DateTime.now(),
                          currentUser.contactId,
                          1,
                          studentFound.id!.toInt(),
                          1,
                          student: studentFound,
                          group: widget.group);

                      addCustomGroupPerson(customGroupPerson);
                      // attednaceResults = [];
                      setState(() {});

                      Navigator.pop(context);
                    },
                    child: Text('Add'),
                  )
                else
                  Text('Student Not Found'),
              ],
            ),
          ),
        );
      },
    );
  }
}
