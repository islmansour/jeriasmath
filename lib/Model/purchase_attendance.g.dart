// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase_attendance.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PurchaseAttendance _$PurchaseAttendanceFromJson(Map<String, dynamic> json) =>
    PurchaseAttendance(
      id: json['id'] as int?,
      purchase: json['purchase'] == null
          ? null
          : Purchase.fromJson(json['purchase'] as Map<String, dynamic>),
      studentAttendance: json['studentAttendance'] == null
          ? null
          : StudentAttendance.fromJson(
              json['studentAttendance'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PurchaseAttendanceToJson(PurchaseAttendance instance) =>
    <String, dynamic>{
      'id': instance.id,
      'purchase': instance.purchase,
      'studentAttendance': instance.studentAttendance,
    };
