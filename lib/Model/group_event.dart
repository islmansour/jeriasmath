import 'package:jerias_math/Model/group.dart';
import 'dart:convert';
//flutter packages pub run build_runner build
import 'package:json_annotation/json_annotation.dart';

part 'group_event.g.dart';

@JsonSerializable()
class GroupEvent {
  int? id;
  int? createdBy;
  DateTime? created;
  DateTime? lastUpdated;
  int? lastUpdatedBy;
  int? status;

  @JsonKey(includeFromJson: true, includeToJson: true)
  Group? group;

  GroupEvent(this.created, this.createdBy, this.group, this.id,
      this.lastUpdated, this.lastUpdatedBy, this.status);

  factory GroupEvent.fromJson(Map<String, dynamic> json) =>
      _$GroupEventFromJson(json);

  //Map<String, dynamic> toJson() => _$GroupEventToJson(this);
  Map<String, dynamic> toJson() =>
      _$GroupEventToJson(this)..['group'] = group!.toJson();
}

List<GroupEvent> groupEventFromJson(String str) {
  return List<GroupEvent>.from(
      json.decode(str).map((x) => GroupEvent.fromJson(x)));
}

String groupEventToJson(List<GroupEvent> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
