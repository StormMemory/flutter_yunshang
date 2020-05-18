import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/CodeEntity.dart';
import 'package:futures/entity/CommentBean.dart';
import 'package:futures/entity/CommentListEntity.dart';
import 'package:futures/entity/TalkBean.dart';
import 'package:futures/personal/persional_information.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:futures/station/Login.dart';
import 'package:futures/api/APIService.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// 动态详情
class ForumDetail extends StatefulWidget {
  final TalkBean talkBean;
  ForumDetail({Key key, this.talkBean}) : super(key: key);

  @override
  _ForumDetailState createState() => _ForumDetailState();
}

class _ForumDetailState extends State<ForumDetail> {
  RefreshController _refreshController;
  List<CommentBean> _commentList = List();
  int page = 1;
  TextEditingController _editingController;
  TextEditingController _reportTalkController;
  var _followStatust = "未关注";
  bool _hasZan = false;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
    _editingController = TextEditingController();
    _reportTalkController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    _hasZan = widget.talkBean.hasZan;
    return Scaffold(
      appBar: _appBar(),
      body: _body(),
    );
  }

  ///顶部导航栏
  Widget _appBar() => AppBar(
        actions: <Widget>[
          Container(
            alignment: Alignment.center,
            child: IconButton(
              onPressed: _operatingWindow,
              icon: Icon(
                Icons.more_horiz,
                size: 30,
              ),
            ),
          )
        ],
        backgroundColor: ColorConfig.appBarColor,
      );

  /// 主体布局
  Widget _body() => Stack(
        alignment: Alignment.bottomLeft,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 61),
            child: _refresher(),
          ),
          Divider(
            height: 1,
            color: ColorConfig.divColor,
          ),
          Container(
            alignment: Alignment.centerLeft,
            width: double.infinity,
            height: 60,
            padding: EdgeInsets.only(left: 20, right: 20),
            color: Colors.white,
            child: _comment(),
          )
        ],
      );

  //举报信息输入框
  _reportTalkDynamicWindow() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext mbc) {
          return Container(
            height: 240,
            padding: EdgeInsets.all(10),
            child: Flex(
              direction: Axis.vertical,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorConfig.appBarColor, width: 1.0),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  margin: EdgeInsets.only(left: 10, right: 10),
                  child: TextField(
                    maxLines: 6,
                    minLines: 6,
                    controller: _reportTalkController,
                    decoration: InputDecoration(
                      hintText: "请输入举报原图！",
                      contentPadding: EdgeInsets.only(
                          left: 10, right: 10, top: 5, bottom: 5),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //举报
                    if (_reportTalkController.text.trim().length < 1) {
                      toastShow("请输入举报内容！");
                      return;
                    }
                    Navigator.pop(mbc);
                    reportTalkDynamic(_reportTalkController.text);
                  },
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: ColorConfig.appBarColor,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    margin: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "举报",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  /// 底部评论输入框
  Widget _comment() => Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            child: _commentInputView(),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            child: IconButton(
              onPressed: _zan,
              icon: Icon(
                Icons.star,
                size: 30,
                color: _hasZan ? ColorConfig.appBarColor : Colors.black45,
              ),
            ),
          )
        ],
      );

  Widget _commentInputView() => Container(
        decoration: BoxDecoration(
          //背景
          border: Border.all(color: ColorConfig.appBarColor, width: 1.0),
          //设置��周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        height: 35,
        child: Flex(
          direction: Axis.horizontal,
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _editingController,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  border: InputBorder.none,
                  hintText: "我来说两句..",
                ),
              ),
            ),
            GestureDetector(
              onTap: commentTalk,
              child: Container(
                height: 35,
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    //背景
                    color: ColorConfig.appBarColor,
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(0.0),
                        bottomLeft: Radius.circular(0.0),
                        topRight: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0))),
                child: Text(
                  "评论",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      );

  // 点赞
  void _zan() {
    if (Provider.of<MyProvider>(context).getUser() == null) {
      toastShow("请先登录后再操作！");
      return;
    }
    APIService.instance.putService(ApiConfig.userTalkOperation, parameters: {
      "userId": Provider.of<MyProvider>(context).getUser().id,
      "talkId": widget.talkBean.id,
      "type": "2"
    }).then((response) async {
      CodeEntity codeEntity = CodeEntity.fromJson(response.data);
      if (codeEntity.success) {
        toastShow("收藏成功！");
        _hasZan = !_hasZan;
        setState(() {});
      } else {
        toastShow(AppConfig.onErrorMsg);
      }
    }).catchError((onError) async {
      toastShow(AppConfig.onErrorMsg);
    });
  }

  // 评论说说
  commentTalk() {
    if (Provider.of<MyProvider>(context).getUser() == null) {
      toastShow("请先登录后再评论！");
      return;
    }
    var content = _editingController.text;
    if (content.trim().isEmpty) {
      toastShow("请输入评论内容！");
      return;
    }
    APIService.instance.postService(ApiConfig.commentTalk, parameters: {
      "userId": Provider.of<MyProvider>(context).getUser().id,
      "talkId": widget.talkBean.id,
      "content": content
    }).then((response) async {
      CodeEntity codeEntity = CodeEntity.fromJson(response.data);
      if (codeEntity.success) {
        toastShow("发表成功");
        _editingController.text = "";
        page = 1;
        setState(() {
          getCommentList();
        });
      } else {
        toastShow(AppConfig.onErrorMsg);
      }
    }).catchError((onError) async {
      toastShow(AppConfig.onErrorMsg);
    });
  }

  // 刷新和加载更多控件
  Widget _refresher() => SmartRefresher(
        key: widget.key,
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: refresh,
        onLoading: loadMore,
        header: refreshView(),
        footer: lodeMoreView(),
        child: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(10),
                color: Colors.white,
                child: Flex(
                  direction: Axis.vertical,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Flex(
                      direction: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (_) {
                              return PersionalInformation(
                                id: widget.talkBean.user.id,
                              );
                            }));
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        widget.talkBean.user.head))),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10, top: 2),
                          width: MediaQuery.of(context).size.width / 1.8,
                          child: Flex(
                            direction: Axis.vertical,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.talkBean.user.nickName,
                                style: TextStyle(
                                    color: ColorConfig.appBarColor,
                                    fontSize: 16),
                              ),
                              Text(
                                widget.talkBean.user.signature.isEmpty
                                    ? "该用户很懒，什么都没留下！"
                                    : widget.talkBean.user.signature,
                                style: TextStyle(
                                    color: Colors.black45, fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(right: 10),
                            alignment: Alignment.topRight,
                            child: Container(
                              width: 70,
                              height: 26,
                              margin: EdgeInsets.only(top: 10),
                              alignment: Alignment.bottomCenter,
                              padding: EdgeInsets.only(top: 2, bottom: 2),
                              decoration: BoxDecoration(
                                color: ColorConfig.appBarColor,
                                border: Border.all(
                                  color: Color.fromRGBO(255, 255, 255, 1),
                                ),
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _follow(
                                      _followStatust == "未关注" ? true : false);
                                },
                                child: Text(_followStatust,
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.only(left: 50, right: 10, top: 10),
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 20, right: 20),
                      decoration: BoxDecoration(
                        //背景
                        color: ColorConfig.appBarColor,
                        //设置四周圆角 角度
                        borderRadius: BorderRadius.all(
                          Radius.circular(15)
                          // bottomLeft: Radius.circular(20.0),
                          // topRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            widget.talkBean.content,
                            style: TextStyle(color: Colors.white),
                          ),
                          _getPic(widget.talkBean.picture),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "| 评论",
                  style:
                      TextStyle(fontSize: 14, color: ColorConfig.appBarColor),
                ),
              ),
              CustomScrollView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                slivers: <Widget>[
                  SliverPadding(
                    padding: const EdgeInsets.all(0),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate(
                        <Widget>[
                          _commentList.isNotEmpty
                              ? ListView.separated(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _commentList.length,
                                  itemBuilder: _commentItem,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider(
                                      height: 5.0,
                                      color: Colors.white,
                                      indent: 0.0,
                                    );
                                  },
                                )
                              : SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );

  refresh() {
    page = 1;
    getCommentList();
    _isFollow();
  }

  loadMore() {
    page++;
    getCommentList();
  }

  Widget refreshView() => WaterDropHeader(
        waterDropColor: ColorConfig.refreshIndicatorColor,
      );

  Widget lodeMoreView() => CustomFooter(
        builder: (BuildContext context, LoadStatus mode) {
          Widget body;
          if (mode == LoadStatus.idle) {
            body = Text("上拉加载更多");
          } else if (mode == LoadStatus.loading) {
            body = CupertinoActivityIndicator(animating: true);
          } else if (mode == LoadStatus.failed) {
            body = Text("加载失败，请重试");
          } else {
            body = Text("暂无更多数据");
          }
          return Container(
            height: 50.0,
            child: Center(child: body),
          );
        },
      );

  Widget _getPic(String pic) {
    if (pic.isEmpty) {
      return Text("");
    } else {
      List<String> _picList = pic.split(",");
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(_picList[0]),
        ),
      );
    }
  }

  // 评论列表
  Widget _commentItem(BuildContext context, int index) => Container(
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Flex(
          direction: Axis.vertical,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              _commentList[index].user.head.isEmpty
                                  ? AppConfig.defaultPic
                                  : _commentList[index].user.head))),
                ),
                Container(
                  margin: EdgeInsets.only(left: 10, top: 2),
                  child: Flex(
                    direction: Axis.vertical,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        _commentList[index].user.nickName,
                        style: TextStyle(
                            color: ColorConfig.appBarColor, fontSize: 16),
                      ),
                      Text(
                        _commentList[index].user.signature.isEmpty
                            ? "该用户很懒，什么都没留下！"
                            : _commentList[index].user.signature,
                        style: TextStyle(color: Colors.black45, fontSize: 12),
                      )
                    ],
                  ),
                )
              ],
            ),
            Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(left: 50, right: 10, top: 10),
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              decoration: BoxDecoration(
                //背景
                color: ColorConfig.appBarColor,
                //设置四周圆角 角度
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                ),
              ),
              child: Text(
                _commentList[index].content,
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      );

  // 关注和取消关注
  _follow(bool isFollow) {
    if (Provider.of<MyProvider>(context).getUser() == null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return Login();
      }));
    } else {
      APIService.instance.postService(ApiConfig.follow, parameters: {
        "userId":
            Provider.of<MyProvider>(context).getUser().id.toString(),
        "followerId": widget.talkBean.user.id,
        "isFollow": isFollow
      }).then((responser) async {
        CodeEntity codeEntity = CodeEntity.fromJson(responser.data);
        if (codeEntity.success) {
          if (isFollow) {
            toastShow("关注成功");
            _followStatust = "已关注";
          } else {
            toastShow("取消关注成功");
            _followStatust = "未关注";
          }
          setState(() {});
        } else {
          toastShow(codeEntity.msg);
        }
      }).catchError((onError) async {
        toastShow(AppConfig.onErrorMsg);
      });
    }
  }

  // 举报动态
  reportTalkDynamic(String content) {
    APIService.instance.postService(ApiConfig.reportTalk, parameters: {
      "userId": Provider.of<MyProvider>(context).getUser() == null
          ? ""
          : Provider.of<MyProvider>(context).getUser().id,
      "talkId": widget.talkBean.id,
      "content": content,
    }).then((response) async {
      CodeEntity codeEntity = CodeEntity.fromJson(response.data);
      if (codeEntity.success && codeEntity.data) {
        toastShow("举报成功！");
      } else {
        toastShow(AppConfig.onErrorMsg);
      }
    }).catchError((onError) async {
      toastShow(AppConfig.onErrorMsg);
    });
  }

  // 是否关注
  _isFollow() {
    if (Provider.of<MyProvider>(context).getUser() == null) {
      return;
    }
    APIService.instance.getService(ApiConfig.isFollow, queryParameters: {
      "userId": Provider.of<MyProvider>(context).getUser().id,
      "followerId": widget.talkBean.user.id
    }).then((response) async {
      // print(response.data);
      CodeEntity codeEntity = CodeEntity.fromJson(response.data);
      if (codeEntity.success) {
        _followStatust = codeEntity.data ? "已关注" : "未关注";
        setState(() {});
      }
    }).catchError((onError) async {});
  }

  // 获取评论列表
  getCommentList() {
    APIService.instance.postService(ApiConfig.getCommentList, data: {
      "_orderByDesc": "publishTime",
      "_pageNumber": page,
      "talkId": widget.talkBean.id
    }).then((response) async {
      CommentListEntity commentListEntity =
          CommentListEntity.fromJson(response.data);
      if (commentListEntity.success &&
          commentListEntity.data.list != null &&
          commentListEntity.data.list.length > 0) {
        if (page == 1) {
          _commentList.clear();
        }
        _commentList.addAll(commentListEntity.data.list);
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
      _refreshController.refreshCompleted();
      setState(() {});
    }).catchError((onError) async {
      toastShow(AppConfig.onErrorMsg);
      _refreshController.loadFailed();
      _refreshController.refreshCompleted();
      setState(() {});
    });
  }

  /// 提示弹出框
  toastShow(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }

  // 内容筛选弹出框
  _operatingWindow() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext mbc) {
          return Container(
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    "内容有问题？你可以试试：",
                    style: TextStyle(color: Colors.black38, fontSize: 14),
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.black12,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(mbc);
                    //屏蔽
                    _blockDynamic();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "屏蔽",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                Divider(
                  height: 1,
                  indent: 10,
                  endIndent: 10,
                  color: Colors.black12,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(mbc);
                    //举报
                    _reportTalkDynamicWindow();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "举报",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                  ),
                ),
                Divider(
                  indent: 10,
                  endIndent: 10,
                  height: 1,
                  color: Colors.black12,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(mbc);
                  },
                  child: Container(
                    padding: EdgeInsets.all(20),
                    alignment: Alignment.center,
                    child: Text(
                      "取消",
                      style: TextStyle(color: ColorConfig.appBarColor),
                    ),
                  ),
                )
              ],
            ),
          );
        });
  }

  // 屏蔽
  void _blockDynamic() {
    if (Provider.of<MyProvider>(context).getUser() == null) {
      toastShow("请先登录！");
      return;
    }
    APIService.instance.postService(ApiConfig.block, parameters: {
      "userId": Provider.of<MyProvider>(context).getUser().id,
      "data": widget.talkBean.id,
      "type": 2
    }).then((response) async {
      CodeEntity codeEntity = CodeEntity.fromJson(response.data);
      if (codeEntity.success && codeEntity.data) {
        toastShow("屏蔽成功！");
      } else {
        toastShow(AppConfig.onErrorMsg);
      }
    }).catchError((onError) async {
      toastShow(AppConfig.onErrorMsg);
    });
  }
}
