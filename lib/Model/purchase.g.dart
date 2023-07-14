// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      id: json['id'] as int?,
      createdBy: json['createdBy'] == null
          ? null
          : Person.fromJson(json['createdBy'] as Map<String, dynamic>),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      lastUpdatedBy: json['lastUpdatedBy'] == null
          ? null
          : Person.fromJson(json['lastUpdatedBy'] as Map<String, dynamic>),
      status: json['status'] as int?,
      student: json['student'] == null
          ? null
          : Person.fromJson(json['student'] as Map<String, dynamic>),
      amount: json['amount'],
      maxAttendances: json['maxAttendances'] as int?,
      autoGenerate: json['autoGenerate'] as bool?,
      account: json['account'] == null
          ? null
          : Account.fromJson(json['account'] as Map<String, dynamic>),
      payments: (json['payments'] as List<dynamic>?)
          ?.map((e) =>
              e == null ? null : Payment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PurchaseToJson(Purchase instance) => <String, dynamic>{
      'id': instance.id,
      'created': instance.created?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'status': instance.status,
      'amount': instance.amount,
      'maxAttendances': instance.maxAttendances,
      'autoGenerate': instance.autoGenerate,
      'account': instance.account,
      'lastUpdatedBy': instance.lastUpdatedBy,
      'student': instance.student,
      'createdBy': instance.createdBy,
      'payments': instance.payments,
    };
