// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RelationshipBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationshipBean _$RelationshipBeanFromJson(Map<String, dynamic> json) {
  return RelationshipBean()
    ..currentPage = json['currentPage'] as int
    ..hasMore = json['hasMore'] as bool
    ..list = (json['list'] as List)
        ?.map((e) =>
            e == null ? null : UserBean.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..pageSize = json['pageSize'] as int
    ..totalPage = json['totalPage'] as int
    ..totalSize = json['totalSize'] as int;
}

Map<String, dynamic> _$RelationshipBeanToJson(RelationshipBean instance) =>
    <String, dynamic>{
      'currentPage': instance.currentPage,
      'hasMore': instance.hasMore,
      'list': instance.list,
      'pageSize': instance.pageSize,
      'totalPage': instance.totalPage,
      'totalSize': instance.totalSize,
    };
