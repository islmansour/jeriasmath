import 'package:json_annotation/json_annotation.dart';
import 'dart:convert';

part 'lookup_table.g.dart';

@JsonSerializable()
class LookupTable {
  final int? code;
  final String? type;
  final String? value;
  final int? seq;
  final bool? active;
  final String? desc;
  final String? lang;

  LookupTable(
      {this.code,
      this.type,
      this.value,
      this.seq,
      this.active,
      this.desc,
      this.lang});

  factory LookupTable.fromJson(Map<String, dynamic> json) =>
      _$LookupTableFromJson(json);

  Map<String, dynamic> toJson() => _$LookupTableToJson(this);
}

List<LookupTable> lookupTableFromJson(String str) {
  print(str);
  return List<LookupTable>.from(
      json.decode(str).map((x) => LookupTable.fromJson(x)));
}

String lookupTableToJson(List<LookupTable> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
