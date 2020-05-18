import 'package:json_annotation/json_annotation.dart';

import 'config_bean.dart';

part 'mock_controller_bean.g.dart';

@JsonSerializable()
class MockControllerBean {
  MockControllerBean();

  String version;
  String isLeanCloud;
  ConfigBean config;

  factory MockControllerBean.fromJson(Map<String, dynamic> json) =>
      _$MockControllerBeanFromJson(json);

  Map<String, dynamic> toJson() => _$MockControllerBeanToJson(this);
}
