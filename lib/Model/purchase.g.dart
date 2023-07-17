// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'purchase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Purchase _$PurchaseFromJson(Map<String, dynamic> json) => Purchase(
      id: json['id'] as int?,
      createdBy:
          Purchase._personFromJson(json['createdBy'] as Map<String, dynamic>?),
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      lastUpdatedBy: Purchase._personFromJson(
          json['lastUpdatedBy'] as Map<String, dynamic>?),
      status: json['status'] as int?,
      student:
          Purchase._personFromJson(json['student'] as Map<String, dynamic>?),
      amount: json['amount'],
      maxAttendances: json['maxAttendances'] as int?,
      autoGenerate: json['autoGenerate'] as bool?,
      account:
          Purchase._accountFromJson(json['account'] as Map<String, dynamic>?),
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
      'account': Purchase._accountToJson(instance.account),
      'lastUpdatedBy': Purchase._personToJson(instance.lastUpdatedBy),
      'student': Purchase._personToJson(instance.student),
      'createdBy': Purchase._personToJson(instance.createdBy),
      'payments': instance.payments,
    };
