// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NewsContentEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsContentEntity _$NewsContentEntityFromJson(Map<String, dynamic> json) {
  return NewsContentEntity()
    ..msg = json['msg'] as String
    ..code = json['code'] as String
    ..name = json['name'] as String
    ..config = json['config'] == null
        ? null
        : ConfigBean.fromJson(json['config'] as Map<String, dynamic>);
}

Map<String, dynamic> _$NewsContentEntityToJson(NewsContentEntity instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'code': instance.code,
      'name': instance.name,
      'config': instance.config,
    };
