import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Screens/manager/edit_student.dart';
import 'package:jerias_math/Screens/manager/manager_student_card.dart';
import 'package:jerias_math/api/django_server_api.dart';

import 'package:jerias_math/l10n/locale_keys.g.dart';

class StudentsListPage extends StatefulWidget {
  const StudentsListPage({super.key});

  @override
  State<StudentsListPage> createState() => _StudentsListPageState();
}

class _StudentsListPageState extends State<StudentsListPage> {
  String _search = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  // Rest of the code remains the same
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //Navigator.pushNamed(context, '/add_student');
          final results = await Navigator.push(
            context,
            MaterialPageRoute(
              //  builder: (context) => StudentPurchasesList(
              builder: (context) => EditStudentFormPage(),
            ),
          );
          if (results == true) {
            setState(() {});
          }
        },
        child: const Icon(Icons.add),
        // backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        title: Text(LocaleKeys.students.tr()),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              // Add any necessary TextField properties here
              decoration: InputDecoration(
                labelText: LocaleKeys.writeToSearch.tr(),
              ),
              onChanged: (query) {
                setState(() {
                  _search = query;
                });
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Person?>?>(
              future: Repository().getPersonsAPI(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<Person?> students = snapshot.data!
                      .where((element) => element!.type == 0)
                      .toList();
                  if (_search != "") {
                    students = students
                        .where((element) =>
                            (element!.firstName!.contains(_search) ||
                                element.lastName!.contains(_search)))
                        .toList();
                  }
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      final payment = students[index];
                      return MgrStudentCard(student: payment!);
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
        ],
      ),
    );
  }
}
