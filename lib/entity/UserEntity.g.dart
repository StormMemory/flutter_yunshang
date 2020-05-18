// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserEntity _$UserEntityFromJson(Map<String, dynamic> json) {
  return UserEntity()
    ..msg = json['msg'] as String
    ..success = json['success'] as bool
    ..userBean = json['data'] == null
        ? null
        : UserBean.fromJson(json['data'] as Map<String, dynamic>);
}

Map<String, dynamic> _$UserEntityToJson(UserEntity instance) =>
    <String, dynamic>{
      'msg': instance.msg,
      'success': instance.success,
      'data': instance.userBean,
    };
