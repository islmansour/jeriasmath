import 'dart:async' show Future;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/person_group.dart';

import 'package:jerias_math/Model/user.dart';
import 'package:path_provider/path_provider.dart';

// Future<AppUser?> getUser(String userId) async {
//   Uri filePath =
//   final jsonString = File.fromUri('test/user_data.json').readAsString();
//   //final jsonString = await File('test/user_data.json').readAsString();
//   print(jsonString);
//   return null;
// }

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<AppUser?> getUser(String uid) async {
  try {
    var s = await rootBundle.loadString('assets/user_data.json');
    final appUser = AppUser.fromJson(jsonDecode(s));
    return appUser;
  } catch (e) {
    print(e.toString());
    // If encountering an error, return 0
    return null;
  }
}

// Future<List<GroupPerson?>?> getGroupPersonsByStudent(int studentId) async {
//   try {
//     var s = await rootBundle.loadString('assets/group_person_data.json');

//     List<dynamic> jsonList = json.decode(s);
//     GroupPerson dummy = GroupPerson(
//         DateTime.now(), '-1', -1, -1, DateTime.now(), "-1", "-1", -1);
//     final List<GroupPerson?> groupStudents = jsonList.map((info) {
//       dummy = GroupPerson(
//           DateTime.now(), '-1', -1, -1, DateTime.now(), "-1", "-1", -1);

//       if (info['studentId'] == studentId) dummy = GroupPerson.fromJson(info);

//       return dummy;
//     }).toList();

//     return groupStudents
//         .where((element) => element?.studentId == studentId)
//         .toList();
//   } catch (e) {
//     print(e.toString());
//     // If encountering an error, return 0
//     return null;
//   }
// }

// Future<List<GroupPerson?>?> getGroupPersons() async {
//   try {
//     var s = await rootBundle.loadString('assets/group_person_data.json');

//     List<dynamic> jsonList = json.decode(s);
//     GroupPerson dummy = GroupPerson(
//         DateTime.now(), '-1', -1, -1, DateTime.now(), "-1", "-1", -1);
//     final List<GroupPerson?> groupStudents = jsonList.map((info) {
//       dummy = GroupPerson(
//           DateTime.now(), '-1', -1, -1, DateTime.now(), "-1", "-1", -1);

//       dummy = GroupPerson.fromJson(info);

//       return dummy;
//     }).toList();

//     return groupStudents.toList();
//   } catch (e) {
//     print(e.toString());
//     // If encountering an error, return 0
// //     return null;
// //   }
// // }

// Future<List<Group?>?> getGroups() async {
//   try {
//     var s = await rootBundle.loadString('assets/group_data.json');
//     List<dynamic> jsonList = json.decode(s);
//     Group dummy =
//         Group(-1, -1, DateTime.now(), "-1", DateTime.now(), null, -1, -1, '');
//     final List<Group?> groups = jsonList.map((info) {
//       dummy = Group.fromJson(info);

//       return dummy;
//     }).toList();

//     return groups.toList();
//   } catch (e) {
//     print(e.toString());
//     // If encountering an error, return 0
//     return null;
//   }
// }
