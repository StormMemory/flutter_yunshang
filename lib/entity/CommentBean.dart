import 'package:futures/entity/TalkBean.dart';
import 'package:futures/entity/UserBean.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CommentBean.g.dart';

@JsonSerializable()
class CommentBean {
  CommentBean();
  
  String content;
  int id;
  int matchId;
  int publishTime;
  TalkBean talk;
  int talkId;
  UserBean user;
  int userId;
  int videoId;

  factory CommentBean.fromJson(Map<String, dynamic> json) =>
      _$CommentBeanFromJson(json);

  Map<String, dynamic> toJson() => _$CommentBeanToJson(this);
}
