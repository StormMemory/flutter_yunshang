

import 'package:json_annotation/json_annotation.dart';

import 'BaseEntity.dart';

part 'CodeEntity.g.dart';

@JsonSerializable()
class CodeEntity extends BaseEntity{
  CodeEntity({this.data});

   @JsonKey(name: 'data')
  bool data;


  factory CodeEntity.fromJson(Map<String, dynamic> json) =>
      _$CodeEntityFromJson(json);

  Map<String, dynamic> toJson() => _$CodeEntityToJson(this);
}