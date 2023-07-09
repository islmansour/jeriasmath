import 'dart:convert';
//flutter packages pub run build_runner build

import 'package:jerias_math/Model/group_event.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_attendance.g.dart';

@JsonSerializable()
class StudentAttendance {
  int id;
  int createdBy;
  DateTime created;
  DateTime lastUpdated;
  int lastUpdatedBy;
  int status; //LOV ATTENDED, DID NOT ATTEND, FREE

  @JsonKey(includeFromJson: true, includeToJson: true)
  late GroupEvent groupEvent;
  Person student;

  set setGroupEvent(GroupEvent ge) {
    groupEvent = ge;
  }

  StudentAttendance(
      {required this.created,
      required this.createdBy,
      required this.id,
      required this.lastUpdated,
      required this.lastUpdatedBy,
      required this.status,
      required this.student});

  factory StudentAttendance.fromJson(Map<String, dynamic> json) =>
      _$StudentAttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$StudentAttendanceToJson(this);

  // Define custom serialization logic for groupEvent
  Map<String, dynamic> _groupEventToJson(GroupEvent? groupEvent) {
    if (groupEvent != null) {
      return groupEvent.toJson();
    }
    return {};
  }

  // Define custom serialization logic for student
  Map<String, dynamic> _studentToJson(Person? student) {
    if (student != null) {
      return student.toJson();
    }
    return {};
  }
}

List<StudentAttendance> studentAttendanceFromJson(String str) {
  return List<StudentAttendance>.from(
      json.decode(str).map((x) => StudentAttendance.fromJson(x)));
}

String studentAttendanceToJson(List<StudentAttendance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
