import 'package:json_annotation/json_annotation.dart';

import 'ConfigBean.dart';

part 'NewsContentEntity.g.dart';

@JsonSerializable()
class NewsContentEntity {
  NewsContentEntity();

  String msg;
  String code;
  String name;
  ConfigBean config;

  factory NewsContentEntity.fromJson(Map<String, dynamic> json) =>
      _$NewsContentEntityFromJson(json);

  Map<String, dynamic> toJson() => _$NewsContentEntityToJson(this);
}
