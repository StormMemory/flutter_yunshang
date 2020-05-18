// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NewsTypeEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsTypeEntity _$NewsTypeEntityFromJson(Map<String, dynamic> json) {
  return NewsTypeEntity()
    ..newsId = json['newsId'] as String
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..objectId = json['objectId'] as String
    ..content = json['content'] == null
        ? null
        : NewsContentEntity.fromJson(json['content'] as Map<String, dynamic>);
}

Map<String, dynamic> _$NewsTypeEntityToJson(NewsTypeEntity instance) =>
    <String, dynamic>{
      'newsId': instance.newsId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'objectId': instance.objectId,
      'content': instance.content,
    };
