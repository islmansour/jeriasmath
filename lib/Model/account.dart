import 'package:jerias_math/Model/person.dart';
//flutter packages pub run build_runner build
import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';
part 'account.g.dart';

@JsonSerializable()
class Account {
  String? name;
  DateTime? startDate;
  int? status;
  DateTime? endDate;

  @JsonKey(includeFromJson: true, includeToJson: true)
  Person? owner;

  Account({
    this.name,
    this.startDate,
    this.status,
    this.endDate,
    this.owner,
  });

  factory Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  Map<String, dynamic> toJson() => _$AccountToJson(this);
}

List<Account> accountFromJson(String str) {
  return List<Account>.from(json.decode(str).map((x) => Account.fromJson(x)));
}

String accountToJson(List<Account> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
