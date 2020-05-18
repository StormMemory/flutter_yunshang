import 'package:futures/entity/TalkBean.dart';
import 'package:futures/entity/UserBean.dart';
import 'package:json_annotation/json_annotation.dart';

part 'InteractiveBean.g.dart';

@JsonSerializable()
class InteractiveBean {
  InteractiveBean();
  String content;
  int id;

  @JsonKey(name: "talk")
  TalkBean talkBean;
  int talkId;
  int time;
  int type;
  UserBean user;
  int userId;

  factory InteractiveBean.fromJson(Map<String, dynamic> json) =>
      _$InteractiveBeanFromJson(json);

  Map<String, dynamic> toJson() => _$InteractiveBeanToJson(this);
}
