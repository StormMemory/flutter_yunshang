// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CodeEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CodeEntity _$CodeEntityFromJson(Map<String, dynamic> json) {
  return CodeEntity(
    data: json['data'] as bool,
  )
    ..msg = json['msg'] as String
    ..success = json['success'] as bool;
}

Map<String, dynamic> _$CodeEntityToJson(CodeEntity instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'success': instance.success,
      'data': instance.data,
    };
