import 'package:futures/entity/NewsContentEntity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'NewsTypeEntity.g.dart';

@JsonSerializable()
class NewsTypeEntity {
  NewsTypeEntity();
  String newsId;
  String createdAt;
  String updatedAt;
  String objectId;

  @JsonKey(name: "content")
  NewsContentEntity content;

  factory NewsTypeEntity.fromJson(Map<String, dynamic> json) =>
      _$NewsTypeEntityFromJson(json);

  Map<String, dynamic> toJson() => _$NewsTypeEntityToJson(this);
}
