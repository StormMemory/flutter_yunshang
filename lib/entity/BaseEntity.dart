
import 'package:json_annotation/json_annotation.dart';

part 'BaseEntity.g.dart';

@JsonSerializable()
class BaseEntity {
  BaseEntity({this.msg, this.success});
  
  String msg;
  
  bool success;
  
  factory BaseEntity.fromJson(Map<String, dynamic> json) =>
    _$BaseEntityFromJson(json);

  Map<String, dynamic> toJson() => _$BaseEntityToJson(this);
}