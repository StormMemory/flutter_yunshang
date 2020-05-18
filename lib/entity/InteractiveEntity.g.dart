// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InteractiveEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InteractiveEntity _$InteractiveEntityFromJson(Map<String, dynamic> json) {
  return InteractiveEntity()
    ..msg = json['msg'] as String
    ..success = json['success'] as bool
    ..data = json['data'] == null
        ? null
        : DataBean.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$InteractiveEntityToJson(InteractiveEntity instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'success': instance.success,
      'data': instance.data,
    };
