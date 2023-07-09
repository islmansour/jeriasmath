// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      DateTime.parse(json['created'] as String),
      json['createdBy'] as int,
      json['id'] as int,
      (json['actualAmount'] as num).toDouble(),
      (json['requiredAmount'] as num).toDouble(),
      DateTime.parse(json['lastUpdated'] as String),
      json['lastUpdatedBy'] as int,
      json['status'] as int,
      json['studentId'] as int,
    )..student = json['student'] == null
        ? null
        : Person.fromJson(json['student'] as Map<String, dynamic>);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'requiredAmount': instance.requiredAmount,
      'actualAmount': instance.actualAmount,
      'createdBy': instance.createdBy,
      'created': instance.created.toIso8601String(),
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'lastUpdatedBy': instance.lastUpdatedBy,
      'status': instance.status,
    };
