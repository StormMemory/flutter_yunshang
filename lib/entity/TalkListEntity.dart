

import 'package:json_annotation/json_annotation.dart';

import 'BaseEntity.dart';
import 'TalkListBean.dart';

part 'TalkListEntity.g.dart';

@JsonSerializable()
class TalkListEntity extends BaseEntity{
  TalkListEntity();

  @JsonKey(name: "data")
  TalkListBean data;

  factory TalkListEntity.fromJson(Map<String, dynamic> json) => _$TalkListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TalkListEntityToJson(this);
}