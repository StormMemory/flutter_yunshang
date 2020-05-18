import 'package:json_annotation/json_annotation.dart';

part 'UserBean.g.dart';

@JsonSerializable()
class UserBean {
  UserBean();

  String uuid;

  int id;

  String phone;

  String password;

  String head;

  String album;

  String nickName;

  String signature;

  int type;

  String projectKey;

  int talkCount;

  int followCount;

  int fansCount;

  factory UserBean.fromJson(Map<String, dynamic> json) =>
      _$UserBeanFromJson(json);

  Map<String, dynamic> toJson() => _$UserBeanToJson(this);
}
