import 'dart:convert';
//flutter packages pub run build_runner build
import 'package:jerias_math/Model/group_event.dart';
import 'package:jerias_math/Model/person.dart';
import 'package:jerias_math/Model/person_group.dart';
import 'package:json_annotation/json_annotation.dart';

part 'group.g.dart';

@JsonSerializable()
class Group {
  int id;
  String name;
  // int teacherId;
  DateTime startDate;
  DateTime endDate;
  String weekDays;
  int type;
  int status;

  @JsonKey(includeFromJson: true, includeToJson: true)
  Person? teacher;
  List<GroupEvent>? groupEvents;
  List<GroupPerson?>? groupStudents;

  Group(
      this.id,
      this.type,
      this.endDate,
      this.name,
      this.startDate,
      this.teacher,
      /*this.teacherId,*/ this.status,
      /* this.time,*/ this.weekDays);

  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);

  Map<String, dynamic> toJson() => _$GroupToJson(this);
}

List<Group> groupFromJson(String str) {
  return List<Group>.from(json.decode(str).map((x) => Group.fromJson(x)));
}

String groupToJson(List<Group> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
