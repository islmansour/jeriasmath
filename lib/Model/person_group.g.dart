// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person_group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupPerson _$GroupPersonFromJson(Map<String, dynamic> json) => GroupPerson(
      DateTime.parse(json['created'] as String),
      json['createdBy'] as int?,
      json['groupId'] as int,
      DateTime.parse(json['lastUpdated'] as String),
      json['lastUpdatedBy'] as int?,
      json['status'] as int,
      json['studentId'] as int,
      json['id'] as int,
      group: json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      student: json['student'] == null
          ? null
          : Person.fromJson(json['student'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$GroupPersonToJson(GroupPerson instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'groupId': instance.groupId,
      'createdBy': instance.createdBy,
      'created': instance.created.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'lastUpdatedBy': instance.lastUpdatedBy,
      'status': instance.status,
      'student': instance.student,
    };
