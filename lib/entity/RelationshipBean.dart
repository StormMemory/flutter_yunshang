

import 'package:json_annotation/json_annotation.dart';

import 'UserBean.dart';

part 'RelationshipBean.g.dart';

@JsonSerializable()
class RelationshipBean {
  RelationshipBean();


  int currentPage;

  bool hasMore;

  List<UserBean> list;

  int pageSize;

  int totalPage;

  int totalSize;

  factory RelationshipBean.fromJson(Map<String, dynamic> json) =>
      _$RelationshipBeanFromJson(json);

  Map<String, dynamic> toJson() => _$RelationshipBeanToJson(this);

}