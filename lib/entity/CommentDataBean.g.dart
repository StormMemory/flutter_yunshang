// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentDataBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentDataBean _$CommentDataBeanFromJson(Map<String, dynamic> json) {
  return CommentDataBean()
    ..currentPage = json['currentPage'] as int
    ..list = (json['list'] as List)
        ?.map((e) =>
            e == null ? null : CommentBean.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..hasMore = json['hasMore'] as bool
    ..pageSize = json['pageSize'] as int
    ..totalPage = json['totalPage'] as int
    ..totalSize = json['totalSize'] as int;
}

Map<String, dynamic> _$CommentDataBeanToJson(CommentDataBean instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'list': instance.list,
      'hasMore': instance.hasMore,
      'pageSize': instance.pageSize,
      'totalPage': instance.totalPage,
      'totalSize': instance.totalSize,
    };
