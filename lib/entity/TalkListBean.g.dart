// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TalkListBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkListBean _$TalkListBeanFromJson(Map<String, dynamic> json) {
  return TalkListBean()
    ..currentPage = json['currentPage'] as int
    ..list = (json['list'] as List)
        ?.map((e) =>
            e == null ? null : TalkBean.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..hasMore = json['hasMore'] as bool
    ..pageSize = json['pageSize'] as int
    ..totalPage = json['totalPage'] as int
    ..totalSize = json['totalSize'] as int;
}

Map<String, dynamic> _$TalkListBeanToJson(TalkListBean instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'list': instance.list,
      'hasMore': instance.hasMore,
      'pageSize': instance.pageSize,
      'totalPage': instance.totalPage,
      'totalSize': instance.totalSize,
    };
