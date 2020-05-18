import 'package:json_annotation/json_annotation.dart';

import 'config_bean.dart';


part 'leanclound_bean.g.dart';

@JsonSerializable()
class LeancloudBean{
  LeancloudBean();

  String version;
  String createdAt;
  String updatedAt;
  String objectId;

  ConfigBean config;


  factory LeancloudBean.fromJson(Map<String, dynamic> json) =>
      _$LeancloudBeanFromJson(json);

  Map<String, dynamic> toJson() => _$LeancloudBeanToJson(this);

}