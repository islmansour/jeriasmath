import 'package:jerias_math/Model/account.dart';
import 'package:jerias_math/Model/payment.dart';
import 'package:jerias_math/Model/person.dart';
import 'dart:convert';
//flutter packages pub run build_runner build

import 'package:json_annotation/json_annotation.dart';

part 'purchase.g.dart';

@JsonSerializable()
class Purchase {
  int? id;
  DateTime? created;
  DateTime? lastUpdated;

  int? status;
  dynamic amount;
  int? maxAttendances;
  final bool? autoGenerate;

  @JsonKey(includeFromJson: true, includeToJson: true)
  Account? account;
  //Payment? payment;
  Person? lastUpdatedBy;
  Person? student;
  Person? createdBy;
  List<Payment?>? payments;

  Purchase({
    this.id,
    this.createdBy,
    this.created,
    this.lastUpdated,
    this.lastUpdatedBy,
    this.status,
    this.student,
    this.amount,
    this.maxAttendances,
    this.autoGenerate,
    this.account,
    this.payments,
  });

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseToJson(this);
}

List<Purchase> purchaseFromJson(String str) {
  return List<Purchase>.from(json.decode(str).map((x) => Purchase.fromJson(x)));
}

String purchaseToJson(List<Purchase> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
