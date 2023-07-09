// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppUser _$AppUserFromJson(Map<String, dynamic> json) => AppUser(
      active: json['active'] as bool?,
      admin: json['admin'] as bool?,
      language: json['language'] as String?,
      userType: json['userType'] as String? ?? "",
      personList: (json['personList'] as List<dynamic>?)
          ?.map((e) => Person.fromJson(e as Map<String, dynamic>))
          .toList(),
      token: json['token'] as String?,
      contactId: json['contactId'] as int?,
      created_by: json['created_by'] as int?,
      uid: json['uid'] as String?,
      id: json['id'] as int?,
    )..person = json['person'] == null
        ? null
        : Person.fromJson(json['person'] as Map<String, dynamic>);

Map<String, dynamic> _$AppUserToJson(AppUser instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'uid': instance.uid,
    'token': instance.token,
    'active': instance.active,
    'contactId': instance.contactId,
    'created_by': instance.created_by,
    'userType': instance.userType,
    'language': instance.language,
    'admin': instance.admin,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('personList', AppUser.toNull(instance.personList));
  return val;
}
