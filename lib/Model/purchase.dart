import 'package:jerias_math/Model/account.dart';
import 'package:jerias_math/Model/payment.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/purchase_attendance.dart';
import 'dart:convert';

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

  @JsonKey(
      includeFromJson: true,
      includeToJson: true,
      toJson: _accountToJson,
      fromJson: _accountFromJson)
  Account? account;

  @JsonKey(
      includeFromJson: true,
      includeToJson: true,
      toJson: _personToJson,
      fromJson: _personFromJson)
  Person? lastUpdatedBy;
  @JsonKey(
      includeFromJson: true,
      includeToJson: true,
      toJson: _personToJson,
      fromJson: _personFromJson)
  Person? student;
  @JsonKey(
      includeFromJson: true,
      includeToJson: true,
      toJson: _personToJson,
      fromJson: _personFromJson)
  Person? createdBy;

  @JsonKey(includeFromJson: true, includeToJson: true)
  List<Payment?>? payments;

  @JsonKey(includeFromJson: true, includeToJson: true)
  List<PurchaseAttendance?>? purchaseAttendance;

  Purchase(
      {this.id,
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
      this.purchaseAttendance});

  factory Purchase.fromJson(Map<String, dynamic> json) =>
      _$PurchaseFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseToJson(this);

  static Account? _accountFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Account.fromJson(json);
  }

  static Map<String, dynamic>? _accountToJson(Account? account) {
    return account?.toJson();
  }

  static Person? _personFromJson(Map<String, dynamic>? json) {
    if (json == null) return null;
    return Person.fromJson(json);
  }

  static Map<String, dynamic>? _personToJson(Person? person) {
    return person?.toJson();
  }
}

List<Purchase> purchaseFromJson(String str) {
  return List<Purchase>.from(json.decode(str).map((x) => Purchase.fromJson(x)));
}

String purchaseToJson(List<Purchase> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
