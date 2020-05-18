// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TalkListEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkListEntity _$TalkListEntityFromJson(Map<String, dynamic> json) {
  return TalkListEntity()
    ..msg = json['msg'] as String
    ..success = json['success'] as bool
    ..data = json['data'] == null
        ? null
        : TalkListBean.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TalkListEntityToJson(TalkListEntity instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'success': instance.success,
      'data': instance.data,
    };
