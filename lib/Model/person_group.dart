import 'dart:convert';
//flutter packages pub run build_runner build
import 'package:jerias_math/Model/group.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:json_annotation/json_annotation.dart';

part 'person_group.g.dart';

@JsonSerializable()
class GroupPerson {
  int id;
  int studentId;
  int groupId;
  int? createdBy;
  DateTime created;
  DateTime lastUpdated;
  int? lastUpdatedBy;
  int status;

  @JsonKey(includeFromJson: true, includeToJson: false)
  Group? group;
  Person? student;
  @override
  String toString() {
    return '${group!.name}';
  }

  GroupPerson(this.created, this.createdBy, this.groupId, this.lastUpdated,
      this.lastUpdatedBy, this.status, this.studentId, this.id,
      {this.group, this.student});

  factory GroupPerson.fromJson(Map<String, dynamic> json) =>
      _$GroupPersonFromJson(json);

  Map<String, dynamic> toJson() => _$GroupPersonToJson(this);
}

List<GroupPerson> groupPersonFromJson(String str) {
  return List<GroupPerson>.from(
      json.decode(str).map((x) => GroupPerson.fromJson(x)));
}

String groupPersonToJson(List<GroupPerson> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
