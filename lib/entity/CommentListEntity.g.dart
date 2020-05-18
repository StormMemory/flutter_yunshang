// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentListEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentListEntity _$CommentListEntityFromJson(Map<String, dynamic> json) {
  return CommentListEntity()
    ..msg = json['msg'] as String
    ..success = json['success'] as bool
    ..data = json['data'] == null
        ? null
        : CommentDataBean.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$CommentListEntityToJson(CommentListEntity instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'success': instance.success,
      'data': instance.data,
    };
