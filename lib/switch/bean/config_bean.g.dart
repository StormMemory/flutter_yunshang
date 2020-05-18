// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_bean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigBean _$ConfigBeanFromJson(Map<String, dynamic> json) {
  return ConfigBean()
    ..base = json['base'] as String
    ..keyA = json['keyA'] as String
    ..keyB = json['keyB'] as String
    ..keyC = json['keyC'] as String
    ..keyD = json['keyD'] as String
    ..keyE = json['keyE'] as String
    ..isAppStore = json['isAppStore'] as String;
}

Map<String, dynamic> _$ConfigBeanToJson(ConfigBean instance) =>
    <String, dynamic>{
      'base': instance.base,
      'keyA': instance.keyA,
      'keyB': instance.keyB,
      'keyC': instance.keyC,
      'keyD': instance.keyD,
      'keyE': instance.keyE,
      'isAppStore': instance.isAppStore,
    };
