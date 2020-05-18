import 'package:json_annotation/json_annotation.dart';

import 'CommentBean.dart';


part 'CommentDataBean.g.dart';

@JsonSerializable()
class CommentDataBean{
  CommentDataBean();
  
  int currentPage;

  List<CommentBean> list;

  bool hasMore;

  int pageSize;

  int totalPage;

  int totalSize;



  factory CommentDataBean.fromJson(Map<String, dynamic> json) => _$CommentDataBeanFromJson(json);

  Map<String, dynamic> toJson() => _$CommentDataBeanToJson(this);
}