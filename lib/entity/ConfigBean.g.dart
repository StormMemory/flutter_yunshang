// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ConfigBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigBean _$ConfigBeanFromJson(Map<String, dynamic> json) {
  return ConfigBean()
    ..isAppStore = json['isAppStore'] as String
    ..keyA = json['keyA'] as String
    ..keyB = json['keyB'] as String
    ..keyC = json['keyC'] as String
    ..keyD = json['keyD'] as String
    ..suspendBtn = json['suspendBtn'] as String
    ..base = json['base'] as String;
}

Map<String, dynamic> _$ConfigBeanToJson(ConfigBean instance) =>
    <String, dynamic>{
      'isAppStore': instance.isAppStore,
      'keyA': instance.keyA,
      'keyB': instance.keyB,
      'keyC': instance.keyC,
      'keyD': instance.keyD,
      'suspendBtn': instance.suspendBtn,
      'base': instance.base,
    };
