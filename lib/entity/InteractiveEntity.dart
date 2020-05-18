import 'package:futures/entity/BaseEntity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'DataBean.dart';

part 'InteractiveEntity.g.dart';

@JsonSerializable()
class InteractiveEntity extends BaseEntity {
  InteractiveEntity();

  @JsonKey(name: "data")
  DataBean data;

  factory InteractiveEntity.fromJson(Map<String, dynamic> json) =>
      _$InteractiveEntityFromJson(json);

  Map<String, dynamic> toJson() => _$InteractiveEntityToJson(this);
}
