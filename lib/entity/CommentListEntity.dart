import 'package:futures/entity/BaseEntity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'CommentDataBean.dart';

part 'CommentListEntity.g.dart';

@JsonSerializable()
class CommentListEntity extends BaseEntity {
  CommentListEntity();

  @JsonKey(name: "data")
  CommentDataBean data;

  factory CommentListEntity.fromJson(Map<String, dynamic> json) => _$CommentListEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CommentListEntityToJson(this);
}
