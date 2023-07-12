// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lookup_table.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LookupTable _$LookupTableFromJson(Map<String, dynamic> json) => LookupTable(
      code: json['code'] as int?,
      type: json['type'] as String?,
      value: json['value'] as String?,
      seq: json['seq'] as int?,
      active: json['active'] as bool?,
      desc: json['desc'] as String?,
      lang: json['lang'] as String?,
    );

Map<String, dynamic> _$LookupTableToJson(LookupTable instance) =>
    <String, dynamic>{
      'code': instance.code,
      'type': instance.type,
      'value': instance.value,
      'seq': instance.seq,
      'active': instance.active,
      'desc': instance.desc,
      'lang': instance.lang,
    };
