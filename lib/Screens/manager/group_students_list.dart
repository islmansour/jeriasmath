import 'package:flutter/material.dart';
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/person_group.dart';
import 'package:jerias_math/Screens/manager/add_student.dart';
import 'package:jerias_math/api/django_server_api.dart';
import 'package:jerias_math/main.dart';
import 'package:jerias_math/Screens/manager/manager_student_card.dart';

class GroupPersonsList extends StatefulWidget {
  final Group? group;

  const GroupPersonsList({super.key, required this.group});

  @override
  // ignore: library_private_types_in_public_api
  _GroupPersonsListState createState() => _GroupPersonsListState();
}

class _GroupPersonsListState extends State<GroupPersonsList> {
  List<GroupPerson?> persons = []; // List to store the fetched persons

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPersons(widget.group!.id);
    });
  }

  void fetchPersons(int groupId) {
    final userData = UserData.of(context);

    if (userData != null && userData.groupPersons != null) {
      final List<GroupPerson?>? allPersons = userData.groupPersons;
      final List<GroupPerson?> persons =
          allPersons!.where((person) => person?.groupId == groupId).toList();
      //setState(() {
      this.persons = persons;
      // });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userData = UserData.of(context);
    final List<GroupPerson?>? allPersons = userData?.groupPersons;

    if (allPersons == null) {
      return const Scaffold(
        // appBar: AppBar(
        //   title: Text('Group Persons'),
        // ),
        body: Center(
          child: Text('No persons found.'),
        ),
      );
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStudentFormPage(group: widget.group),
                ),
              ) ==
              true) setState(() {});
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<GroupPerson?>?>(
        future: Repository().getGroupPersonsAPI(),
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
            final groupStudents = snapshot.data!
                .where((element) => element!.group!.id == widget.group!.id)
                .toList();
            return ListView.builder(
              itemCount: groupStudents.length,
              itemBuilder: (context, index) {
                return MgrStudentCard(student: groupStudents[index]!.student);
              },
            );
          }
        },
      ),
    );
  }
}
