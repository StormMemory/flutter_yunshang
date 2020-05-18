import 'package:futures/entity/BaseEntity.dart';
import 'package:futures/entity/RelationshipBean.dart';
import 'package:json_annotation/json_annotation.dart';

part 'RelationshipEntity.g.dart';

@JsonSerializable()
class RelationshipEntity extends BaseEntity {
  RelationshipEntity();

  RelationshipBean data;

  factory RelationshipEntity.fromJson(Map<String, dynamic> json) =>
      _$RelationshipEntityFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipEntityToJson(this);
}