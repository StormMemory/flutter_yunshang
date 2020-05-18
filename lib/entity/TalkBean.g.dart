// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TalkBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TalkBean _$TalkBeanFromJson(Map<String, dynamic> json) {
  return TalkBean()
    ..browserCount = json['browserCount'] as int
    ..commentCount = json['commentCount'] as int
    ..forwardCount = json['forwardCount'] as int
    ..zanCount = json['zanCount'] as int
    ..content = json['content'] as String
    ..displayBig = json['displayBig'] as bool
    ..enable = json['enable'] as bool
    ..hasZan = json['hasZan'] as bool
    ..id = json['id'] as int
    ..picture = json['picture'] as String
    ..publishTime = json['publishTime'] as int
    ..userId = json['userId'] as int
    ..videoId = json['videoId'] as int
    ..user = json['user'] == null
        ? null
        : UserBean.fromJson(json['user'] as Map<String, dynamic>);
}

Map<String, dynamic> _$TalkBeanToJson(TalkBean instance) => <String, dynamic>{
      'browserCount': instance.browserCount,
      'commentCount': instance.commentCount,
      'forwardCount': instance.forwardCount,
      'zanCount': instance.zanCount,
      'content': instance.content,
      'displayBig': instance.displayBig,
      'enable': instance.enable,
      'hasZan': instance.hasZan,
      'id': instance.id,
      'picture': instance.picture,
      'publishTime': instance.publishTime,
      'userId': instance.userId,
      'videoId': instance.videoId,
      'user': instance.user,
    };
