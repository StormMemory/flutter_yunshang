import 'package:json_annotation/json_annotation.dart';

import 'InteractiveBean.dart';

part 'DataBean.g.dart';

@JsonSerializable()
class DataBean {
  DataBean();

  int currentPage;

  List<InteractiveBean> list;

  bool hasMore;

  int pageSize;

  int totalPage;

  int totalSize;

  factory DataBean.fromJson(Map<String, dynamic> json) =>
      _$DataBeanFromJson(json);

  Map<String, dynamic> toJson() => _$DataBeanToJson(this);
}
