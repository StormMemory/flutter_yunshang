import 'package:json_annotation/json_annotation.dart';

part 'config_bean.g.dart';

@JsonSerializable()
class ConfigBean {
  ConfigBean();

  String base;
  String keyA;
  String keyB;
  String keyC;
  String keyD;
  String keyE;
  String isAppStore;

  factory ConfigBean.fromJson(Map<String, dynamic> json) =>
      _$ConfigBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigBeanToJson(this);
}
