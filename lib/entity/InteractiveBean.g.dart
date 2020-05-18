// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'InteractiveBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InteractiveBean _$InteractiveBeanFromJson(Map<String, dynamic> json) {
  return InteractiveBean()
    ..content = json['content'] as String
    ..id = json['id'] as int
    ..talkBean = json['talk'] == null
        ? null
        : TalkBean.fromJson(json['talk'] as Map<String, dynamic>)
    ..talkId = json['talkId'] as int
    ..time = json['time'] as int
    ..type = json['type'] as int
    ..user = json['user'] == null
        ? null
        : UserBean.fromJson(json['user'] as Map<String, dynamic>)
    ..userId = json['userId'] as int;
}

Map<String, dynamic> _$InteractiveBeanToJson(InteractiveBean instance) =>
    <String, dynamic>{
      'content': instance.content,
      'id': instance.id,
      'talk': instance.talkBean,
      'talkId': instance.talkId,
      'time': instance.time,
      'type': instance.type,
      'user': instance.user,
      'userId': instance.userId,
    };
