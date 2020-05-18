

import 'package:json_annotation/json_annotation.dart';

import 'TalkBean.dart';

part 'TalkListBean.g.dart';

@JsonSerializable()
class TalkListBean{
  TalkListBean();
  
  int currentPage;

  List<TalkBean> list;

  bool hasMore;

  int pageSize;

  int totalPage;

  int totalSize;



  factory TalkListBean.fromJson(Map<String, dynamic> json) => _$TalkListBeanFromJson(json);

  Map<String, dynamic> toJson() => _$TalkListBeanToJson(this);
}