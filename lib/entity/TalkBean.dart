

import 'package:json_annotation/json_annotation.dart';

import 'UserBean.dart';

part 'TalkBean.g.dart';

@JsonSerializable()
class TalkBean {
  TalkBean();

  int browserCount;

  int commentCount;

  int forwardCount;

  int zanCount;

  String content;

  bool displayBig;

  bool enable;

  bool hasZan;

  int id;

  String picture;

  int publishTime;

  int userId;

  // String video;

  int videoId;

  UserBean user;

  factory TalkBean.fromJson(Map<String, dynamic> json) =>
      _$TalkBeanFromJson(json);

  Map<String, dynamic> toJson() => _$TalkBeanToJson(this);
}
