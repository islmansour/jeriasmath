// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
      dob: json['dob'] == null ? null : DateTime.parse(json['dob'] as String),
      email: json['email'] as String?,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      parentPhone1: json['parentPhone1'] as String?,
      id: json['id'] as int?,
      parentPhone2: json['parentPhone2'] as String?,
      phone: json['phone'] as String?,
      startDate: json['startDate'] == null
          ? null
          : DateTime.parse(json['startDate'] as String),
      status: json['status'] as int?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
      'id': instance.id,
      'lastName': instance.lastName,
      'firstName': instance.firstName,
      'startDate': instance.startDate?.toIso8601String(),
      'status': instance.status,
      'phone': instance.phone,
      'email': instance.email,
      'parentPhone1': instance.parentPhone1,
      'parentPhone2': instance.parentPhone2,
      'dob': instance.dob?.toIso8601String(),
      'userId': instance.userId,
    };
