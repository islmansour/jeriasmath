import 'dart:convert';
//flutter packages pub run build_runner build
import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
class Person {
  int? id;
  String? lastName;
  String? firstName;
  final DateTime? startDate;
  int? status;
  String? phone;
  String? email;
  String? parentPhone1;
  String? parentPhone2;
  DateTime? dob;
  final String? userId;
  Person(
      {this.dob,
      this.email,
      this.firstName,
      this.lastName,
      this.parentPhone1,
      this.id,
      this.parentPhone2,
      this.phone,
      this.startDate,
      this.status,
      this.userId});

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}

List<Person> personFromJson(String str) {
  return List<Person>.from(json.decode(str).map((x) => Person.fromJson(x)));
}

String personToJson(List<Person> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
