import 'package:futures/entity/BaseEntity.dart';
import 'package:json_annotation/json_annotation.dart';

import 'BannerBean.dart';

part 'BannerEntity.g.dart';

@JsonSerializable()
class BannerEntity extends BaseEntity {
  BannerEntity();

  @JsonKey(name: "data")
  List<BannerBean> list;

  factory BannerEntity.fromJson(Map<String, dynamic> json) =>
      _$BannerEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BannerEntityToJson(this);
}
