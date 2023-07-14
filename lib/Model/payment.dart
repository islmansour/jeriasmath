import 'dart:convert';
//flutter packages pub run build_runner build
import 'package:jerias_math/Model/account.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/purchase.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  int? id;
  dynamic? amount;
  DateTime? created;
  DateTime? lastUpdated;

  int? paymentType;
  String? chequeNumber;
  String? chequeBank;
  DateTime? chequeDate;
  String? notes;

  @JsonKey(includeFromJson: true, includeToJson: false)
  Person? student;
  Account? account;
  Purchase? purchase;
  Person? createdBy;
  Person? lastUpdatedBy;

  Payment({
    this.purchase,
    this.amount,
    this.created,
    this.lastUpdated,
    this.createdBy,
    this.lastUpdatedBy,
    this.account,
    this.paymentType,
    this.chequeNumber,
    this.chequeBank,
    this.chequeDate,
    this.notes,
  });

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

List<Payment> paymentFromJson(String str) {
  return List<Payment>.from(json.decode(str).map((x) => Payment.fromJson(x)));
}

String paymentToJson(List<Payment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
