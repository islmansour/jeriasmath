import 'dart:convert';
//flutter packages pub run build_runner build
import 'package:jerias_math/Model/purchase.dart';
import 'package:jerias_math/Model/student_attendance.dart';
import 'package:json_annotation/json_annotation.dart';

part 'purchase_attendance.g.dart';

@JsonSerializable()
class PurchaseAttendance {
  int? id;
  @JsonKey(includeFromJson: true, includeToJson: true)
  Purchase? purchase;
  StudentAttendance? studentAttendance;

  PurchaseAttendance({this.id, this.purchase, this.studentAttendance});

  factory PurchaseAttendance.fromJson(Map<String, dynamic> json) =>
      _$PurchaseAttendanceFromJson(json);

  Map<String, dynamic> toJson() => _$PurchaseAttendanceToJson(this);
}

List<PurchaseAttendance> purchaseAttendanceFromJson(String str) {
  return List<PurchaseAttendance>.from(
      json.decode(str).map((x) => PurchaseAttendance.fromJson(x)));
}

String purchaseAttendanceToJson(List<PurchaseAttendance> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
