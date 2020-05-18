// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CommentBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommentBean _$CommentBeanFromJson(Map<String, dynamic> json) {
  return CommentBean()
    ..content = json['content'] as String
    ..id = json['id'] as int
    ..matchId = json['matchId'] as int
    ..publishTime = json['publishTime'] as int
    ..talk = json['talk'] == null
        ? null
        : TalkBean.fromJson(json['talk'] as Map<String, dynamic>)
    ..talkId = json['talkId'] as int
    ..user = json['user'] == null
        ? null
        : UserBean.fromJson(json['user'] as Map<String, dynamic>)
    ..userId = json['userId'] as int
    ..videoId = json['videoId'] as int;
}

Map<String, dynamic> _$CommentBeanToJson(CommentBean instance) =>
    <String, dynamic>{
      'content': instance.content,
      'id': instance.id,
      'matchId': instance.matchId,
      'publishTime': instance.publishTime,
      'talk': instance.talk,
      'talkId': instance.talkId,
      'user': instance.user,
      'userId': instance.userId,
      'videoId': instance.videoId,
    };
