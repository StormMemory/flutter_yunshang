// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBean _$UserBeanFromJson(Map<String, dynamic> json) {
  return UserBean()
    ..uuid = json['uuid'] as String
    ..id = json['id'] as int
    ..phone = json['phone'] as String
    ..password = json['password'] as String
    ..head = json['head'] as String
    ..album = json['album'] as String
    ..nickName = json['nickName'] as String
    ..signature = json['signature'] as String
    ..type = json['type'] as int
    ..projectKey = json['projectKey'] as String
    ..talkCount = json['talkCount'] as int
    ..followCount = json['followCount'] as int
    ..fansCount = json['fansCount'] as int;
}

Map<String, dynamic> _$UserBeanToJson(UserBean instance) => <String, dynamic>{
      'uuid': instance.uuid,
      'id': instance.id,
      'phone': instance.phone,
      'password': instance.password,
      'head': instance.head,
      'album': instance.album,
      'nickName': instance.nickName,
      'signature': instance.signature,
      'type': instance.type,
      'projectKey': instance.projectKey,
      'talkCount': instance.talkCount,
      'followCount': instance.followCount,
      'fansCount': instance.fansCount,
    };
