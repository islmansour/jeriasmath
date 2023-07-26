// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Payment _$PaymentFromJson(Map<String, dynamic> json) => Payment(
      purchase: json['purchase'] == null
          ? null
          : Purchase.fromJson(json['purchase'] as Map<String, dynamic>),
      amount: json['amount'],
      created: json['created'] == null
          ? null
          : DateTime.parse(json['created'] as String),
      lastUpdated: json['lastUpdated'] == null
          ? null
          : DateTime.parse(json['lastUpdated'] as String),
      createdBy: json['createdBy'] == null
          ? null
          : Person.fromJson(json['createdBy'] as Map<String, dynamic>),
      lastUpdatedBy: json['lastUpdatedBy'] == null
          ? null
          : Person.fromJson(json['lastUpdatedBy'] as Map<String, dynamic>),
      account: json['account'] == null
          ? null
          : Account.fromJson(json['account'] as Map<String, dynamic>),
      paymentType: json['paymentType'] as int?,
      chequeNumber: json['chequeNumber'] as String?,
      chequeBank: json['chequeBank'] as String?,
      chequeBranch: json['chequeBranch'] as String?,
      chequeDate: json['chequeDate'] == null
          ? null
          : DateTime.parse(json['chequeDate'] as String),
      notes: json['notes'] as String?,
    )
      ..id = json['id'] as int?
      ..student = json['student'] == null
          ? null
          : Person.fromJson(json['student'] as Map<String, dynamic>);

Map<String, dynamic> _$PaymentToJson(Payment instance) => <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'created': instance.created?.toIso8601String(),
      'lastUpdated': instance.lastUpdated?.toIso8601String(),
      'paymentType': instance.paymentType,
      'chequeNumber': instance.chequeNumber,
      'chequeBank': instance.chequeBank,
      'chequeBranch': instance.chequeBranch,
      'chequeDate': instance.chequeDate?.toIso8601String(),
      'notes': instance.notes,
      'student': instance.student,
      'account': instance.account,
      'purchase': instance.purchase,
      'createdBy': instance.createdBy,
      'lastUpdatedBy': instance.lastUpdatedBy,
    };
