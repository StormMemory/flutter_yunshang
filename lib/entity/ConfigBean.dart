import 'package:json_annotation/json_annotation.dart';

part 'ConfigBean.g.dart';

@JsonSerializable()
class ConfigBean {
  ConfigBean();
  String isAppStore;
  String keyA;
  String keyB;
  String keyC;
  String keyD;
  String suspendBtn;
  String base;

  factory ConfigBean.fromJson(Map<String, dynamic> json) =>
      _$ConfigBeanFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigBeanToJson(this);
}
