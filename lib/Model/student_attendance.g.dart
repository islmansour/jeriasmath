// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentAttendance _$StudentAttendanceFromJson(Map<String, dynamic> json) =>
    StudentAttendance(
      created: DateTime.parse(json['created'] as String),
      createdBy: json['createdBy'] as int,
      id: json['id'] as int,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      lastUpdatedBy: json['lastUpdatedBy'] as int,
      status: json['status'] as int,
      student: Person.fromJson(json['student'] as Map<String, dynamic>),
    )..groupEvent =
        GroupEvent.fromJson(json['groupEvent'] as Map<String, dynamic>);

Map<String, dynamic> _$StudentAttendanceToJson(StudentAttendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdBy': instance.createdBy,
      'created': instance.created.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'lastUpdatedBy': instance.lastUpdatedBy,
      'status': instance.status,
      'groupEvent': instance.groupEvent,
      'student': instance.student,
    };
