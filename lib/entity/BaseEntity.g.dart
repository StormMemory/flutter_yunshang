// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BaseEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BaseEntity _$BaseEntityFromJson(Map<String, dynamic> json) {
  return BaseEntity(
    msg: json['msg'] as String,
    success: json['success'] as bool,
  );
}

Map<String, dynamic> _$BaseEntityToJson(BaseEntity instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'success': instance.success,
    };
