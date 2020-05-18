// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BannerBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerBean _$BannerBeanFromJson(Map<String, dynamic> json) {
  return BannerBean()
    ..data = json['data'] as int
    ..id = json['id'] as int
    ..picturePath = json['picturePath'] as String
    ..project = json['project'] as String
    ..type = json['type'] as int
    ..updateTime = json['updateTime'] as int
    ..url = json['url'] as String;
}

Map<String, dynamic> _$BannerBeanToJson(BannerBean instance) =>
    <String, dynamic>{
      'data': instance.data,
      'id': instance.id,
      'picturePath': instance.picturePath,
      'project': instance.project,
      'type': instance.type,
      'updateTime': instance.updateTime,
      'url': instance.url,
    };
