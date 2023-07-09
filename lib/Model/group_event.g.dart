// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupEvent _$GroupEventFromJson(Map<String, dynamic> json) => GroupEvent(
      json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      json['createdBy'] as int?,
      json['group'] == null
          ? null
          : Group.fromJson(json['group'] as Map<String, dynamic>),
      json['id'] as int?,
      json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      json['lastUpdatedBy'] as int?,
      json['status'] as int?,
    );

Map<String, dynamic> _$GroupEventToJson(GroupEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdBy': instance.createdBy,
      'created': instance.created?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'lastUpdatedBy': instance.lastUpdatedBy,
      'status': instance.status,
      'group': instance.group,
    };
