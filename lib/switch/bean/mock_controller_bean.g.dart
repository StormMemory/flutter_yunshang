// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_controller_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MockControllerBean _$MockControllerBeanFromJson(Map<String, dynamic> json) {
  return MockControllerBean()
    ..version = json['version'] as String
    ..isLeanCloud = json['isLeanCloud'] as String
    ..config = json['config'] == null
        ? null
        : ConfigBean.fromJson(json['config'] as Map<String, dynamic>);
}

Map<String, dynamic> _$MockControllerBeanToJson(MockControllerBean instance) =>
    <String, dynamic>{
      'version': instance.version,
      'isLeanCloud': instance.isLeanCloud,
      'config': instance.config,
    };
