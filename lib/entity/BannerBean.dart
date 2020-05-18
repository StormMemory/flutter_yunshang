import 'package:json_annotation/json_annotation.dart';

part 'BannerBean.g.dart';

@JsonSerializable()
class BannerBean {
  BannerBean();

  int data;
  int id;
  String picturePath;
  String project;
  int type;
  int updateTime;
  String url;

  factory BannerBean.fromJson(Map<String, dynamic> json) =>
      _$BannerBeanFromJson(json);

  Map<String, dynamic> toJson() => _$BannerBeanToJson(this);
}
