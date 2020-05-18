// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RelationshipEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RelationshipEntity _$RelationshipEntityFromJson(Map<String, dynamic> json) {
  return RelationshipEntity()
    ..msg = json['msg'] as String
    ..success = json['success'] as bool
    ..data = json['data'] == null
        ? null
        : RelationshipBean.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$RelationshipEntityToJson(RelationshipEntity instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'success': instance.success,
      'data': instance.data,
    };
