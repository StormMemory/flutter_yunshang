
import 'package:json_annotation/json_annotation.dart';

import 'BaseEntity.dart';
import 'UserBean.dart';

part 'UserEntity.g.dart';

@JsonSerializable()
class UserEntity extends BaseEntity {
  UserEntity();

  @JsonKey(name: "data")
  UserBean userBean;

  factory UserEntity.fromJson(Map<String, dynamic> json) => _$UserEntityFromJson(json);

  Map<String, dynamic> toJson() => _$UserEntityToJson(this);
}
