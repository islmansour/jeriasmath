// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Group _$GroupFromJson(Map<String, dynamic> json) => Group(
      json['id'] as int,
      json['type'] as int,
      DateTime.parse(json['endDate'] as String),
      json['name'] as String,
      DateTime.parse(json['startDate'] as String),
      json['teacher'] == null
          ? null
          : Person.fromJson(json['teacher'] as Map<String, dynamic>),
      json['status'] as int,
      json['weekDays'] as String,
    )
      ..groupEvents = (json['groupEvents'] as List<dynamic>?)
          ?.map((e) => GroupEvent.fromJson(e as Map<String, dynamic>))
          .toList()
      ..groupStudents = (json['groupStudents'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : GroupPerson.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$GroupToJson(Group instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'weekDays': instance.weekDays,
      'type': instance.type,
      'status': instance.status,
      'teacher': instance.teacher,
      'groupEvents': instance.groupEvents,
      'groupStudents': instance.groupStudents,
    };
