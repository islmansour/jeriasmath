import 'dart:convert';
//flutter packages pub run build_runner build
import 'package:json_annotation/json_annotation.dart';

import 'package:jerias_math/Model/person.dart';

part 'user.g.dart';

@JsonSerializable()
class AppUser {
  int? id;
  String? uid;
  String? token;
  bool? active;
  int? contactId;
  int? created_by;
  String? userType;
  String? language;
  bool? admin;

  @JsonKey(includeFromJson: true, includeToJson: false)
  Person? person;

  static toNull(_) => null;
  @JsonKey(toJson: toNull, includeIfNull: false)
  List<Person>? personList;

  AppUser({
    this.active,
    this.admin,
    this.language,
    this.userType = "",
    this.personList,
    //  this.person,
    this.token,
    this.contactId,
    this.created_by,
    this.uid,
    this.id,
  }) {
    if (contactId != null) {
      if (personList != null)
        print('AppUser dart: ' + personList!.length.toString());
      // Repository().getSingleContact(contactId.toString()).then((value) {
      //   if (value != null) {
      //     person = value;
      //   }
      // });
    }
  }

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);

  Map<String, dynamic> toJson() => _$AppUserToJson(this);
}

List<AppUser> userFromJson(String str) {
  return List<AppUser>.from(json.decode(str).map((x) => AppUser.fromJson(x)));
}

String userToJson(List<AppUser> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
