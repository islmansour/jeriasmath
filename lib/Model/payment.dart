import 'dart:convert';
//flutter packages pub run build_runner build
import 'package:jerias_math/Model/person.dart';
import 'package:json_annotation/json_annotation.dart';

part 'payment.g.dart';

@JsonSerializable()
class Payment {
  int id;
  int studentId;
  double requiredAmount;
  double actualAmount;
  int createdBy;
  DateTime created;
  DateTime lastUpdated;
  int lastUpdatedBy;
  int status;

  @JsonKey(includeFromJson: true, includeToJson: false)
  Person? student;

  Payment(
      this.created,
      this.createdBy,
      this.id,
      this.actualAmount,
      this.requiredAmount,
      this.lastUpdated,
      this.lastUpdatedBy,
      this.status,
      this.studentId);

  factory Payment.fromJson(Map<String, dynamic> json) =>
      _$PaymentFromJson(json);

  Map<String, dynamic> toJson() => _$PaymentToJson(this);
}

List<Payment> paymentFromJson(String str) {
  return List<Payment>.from(json.decode(str).map((x) => Payment.fromJson(x)));
}

String paymentToJson(List<Payment> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
