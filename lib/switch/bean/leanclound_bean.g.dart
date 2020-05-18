// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leanclound_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeancloudBean _$LeancloudBeanFromJson(Map<String, dynamic> json) {
  return LeancloudBean()
    ..version = json['version'] as String
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..config = json['config'] == null
        ? null
        : ConfigBean.fromJson(json['config'] as Map<String, dynamic>);
}

Map<String, dynamic> _$LeancloudBeanToJson(LeancloudBean instance) =>
    <String, dynamic>{
      'version': instance.version,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'config': instance.config,
    };
