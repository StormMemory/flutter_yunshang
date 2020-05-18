// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'BannerEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BannerEntity _$BannerEntityFromJson(Map<String, dynamic> json) {
  return BannerEntity()
    ..msg = json['msg'] as String
    ..success = json['success'] as bool
    ..list = (json['data'] as List)
        ?.map((e) =>
            e == null ? null : BannerBean.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$BannerEntityToJson(BannerEntity instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'success': instance.success,
      'data': instance.list,
    };
