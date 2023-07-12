// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupEvent _$GroupEventFromJson(Map<String, dynamic> json) => GroupEvent(
      json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      json['createdBy'] == null
          ? null
          : Person.fromJson(json['createdBy'] as Map<String, dynamic>),
      json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      json['id'] as int?,
      json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      json['lastUpdatedBy'] == null
          ? null
          : Person.fromJson(json['lastUpdatedBy'] as Map<String, dynamic>),
      json['status'] as int?,
    );

Map<String, dynamic> _$GroupEventToJson(GroupEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'created': instance.created?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'status': instance.status,
      'group': instance.group,
      'createdBy': instance.createdBy,
      'lastUpdatedBy': instance.lastUpdatedBy,
    };
