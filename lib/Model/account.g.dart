// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Account _$AccountFromJson(Map<String, dynamic> json) => Account(
      name: json['name'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      status: json['status'] as int?,
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      owner: json['owner'] == null
          ? null
          : Person.fromJson(json['owner'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AccountToJson(Account instance) => <String, dynamic>{
      'name': instance.name,
      'startDate': instance.startDate?.toIso8601String(),
      'status': instance.status,
      'endDate': instance.endDate?.toIso8601String(),
      'owner': instance.owner,
    };
