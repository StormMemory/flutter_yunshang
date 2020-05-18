import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/CodeEntity.dart';
import 'package:futures/entity/TalkBean.dart';
import 'package:futures/entity/TalkListEntity.dart';
import 'package:futures/entity/UserEntity.dart';
import 'package:futures/api/APIService.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PersionalInformation extends StatefulWidget {
  PersionalInformation({Key key, this.id}) : super(key: key);

  final int id;

  @override
  _PersionalInformationState createState() => _PersionalInformationState();
}

class _PersionalInformationState extends State<PersionalInformation> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: ColorConfig.appBarColor,
        ),
        body: _bodyView(),
      );

  var _name = "nickName";
  var _count = "0关注   0粉丝   0动态";
  var _signature = "个性签名：该用户很懒，什么都没留下。";
  var _followStatust = "未关注";
  var _headPic = AppConfig.defaultPic;
  List<TalkBean> _talkBeanList = List();
  int pageNumber = 1;

  RefreshController refreshController;

  // 刷新
  void _refresh() {
    pageNumber = 1;
    _queryUser();
    _isFollow();
    _getTalkList();
  }

  // 加载更多
  void _loadMore() {
    pageNumber++;
    _getTalkList();
  }

  // 查询用户信息
  void _queryUser() {
    APIService.instance.postService(ApiConfig.queryUser,
        parameters: {"userId": widget.id}).then((response) async {
      UserEntity userEntity = UserEntity.fromJson(response.data);
      if (userEntity.success) {
        _headPic = userEntity.userBean.head;
        _name = userEntity.userBean.nickName;
        _count = userEntity.userBean.followCount.toString() +
            "关注     " +
            userEntity.userBean.fansCount.toString() +
            "粉丝     " +
            userEntity.userBean.talkCount.toString() +
            "动态";
        _signature = "个性签名：" + userEntity.userBean.signature;
        setState(() {});
      }
    }).catchError((onError) async {});
  }

  // 是否关注
  void _isFollow() {
    if (Provider.of<MyProvider>(context).getUser() != null)
      APIService.instance.getService(ApiConfig.isFollow, queryParameters: {
        "userId": Provider.of<MyProvider>(context).getUser().id,
        "followerId": widget.id
      }).then((response) async {
        // print(response.data);
        CodeEntity codeEntity = CodeEntity.fromJson(response.data);
        if (codeEntity.success) {
          _followStatust = codeEntity.data ? "已关注" : "未关注";
          setState(() {});
        }
      }).catchError((onError) async {});
  }

  // 获取说说列表
  void _getTalkList() {
    APIService.instance.postService(ApiConfig.getTalkList + widget.id.toString(),
        data: {
          "userId": widget.id,
          "_orderBy": "publishTime",
          "_pageNumber": pageNumber
        }).then((response) async {
      TalkListEntity talkListEntity = TalkListEntity.fromJson(response.data);
      if (talkListEntity.success &&
          talkListEntity.data != null &&
          talkListEntity.data.list != null) {
        if (pageNumber == 1) {
          _talkBeanList.clear();
        }
        _talkBeanList.addAll(talkListEntity.data.list);
        setState(() {});
        if (talkListEntity.data.list.length < 10) {
          refreshController.loadNoData();
        } else {
          refreshController.loadComplete();
        }
        refreshController.refreshCompleted();
      } else {
        setState(() {});
        refreshController.loadFailed();
        refreshController.refreshCompleted();
      }
    }).catchError((onError) {
      _toastShow("当前网络较差，请稍后重试。");
      refreshController.loadFailed();
      refreshController.refreshFailed();
      setState(() {});
    });
  }

  // 刷新控件
  Widget _refreshView() => WaterDropHeader(
        waterDropColor: ColorConfig.refreshIndicatorColor,
      );

  // 加载更多控件
  Widget _lodeMoreView() => CustomFooter(
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

  Widget _bodyView() => SmartRefresher(
        key: widget.key,
        controller: refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _refresh,
        onLoading: _loadMore,
        header: _refreshView(),
        footer: _lodeMoreView(),
        child: SingleChildScrollView(
          child: Flex(
            direction: Axis.vertical,
            children: <Widget>[
              // 用户信息
              _userView(),
              _userInformationView(),
              Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "| 动态",
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
                          _talkBeanList.isNotEmpty
                              ? ListView.separated(
                                  physics: ClampingScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _talkBeanList.length,
                                  itemBuilder: _talkItem,
                                  separatorBuilder:
                                      (BuildContext context, int index) {
                                    return Divider(
                                      height: 1.0,
                                      color: ColorConfig.divColor,
                                      indent: 10.0,
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

  // 用户头像和关注按钮
  Widget _userView() => Container(
        alignment: Alignment.center,
        width: double.infinity,
        padding: EdgeInsets.only(top: 10),
        height: 140,
        color: ColorConfig.appBarColor,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 5.0),
                  borderRadius: BorderRadius.circular(60.0)),
              width: 120,
              height: 120,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Container(
                    width: 120,
                    height: 120,
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.cover, image: NetworkImage(_headPic))),
                  ),
                ],
              ),
            ),
            Container(
              width: 100,
              height: 26,
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(top: 2, bottom: 2),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(0, 0, 0, 0.5),
                  border: Border.all(color: Color.fromRGBO(255, 255, 255, 1)),
                  borderRadius: BorderRadius.circular(20.0)),
              child: GestureDetector(
                onTap: () {
                  _followOrUnfollow(_followStatust == "未关注" ? true : false);
                },
                child: Text(_followStatust,
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
            )
          ],
        ),
      );

  // 用户昵称和签名信息
  Widget _userInformationView() => Container(
        color: ColorConfig.appBarColor,
        width: double.infinity,
        padding: EdgeInsets.only(top: 10),
        child: Column(
          children: <Widget>[
            Text(
              _name,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Container(
              padding: EdgeInsets.only(top: 5),
              child: Text(
                _count,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 5, bottom: 10),
              child: Text(
                _signature,
                style: TextStyle(color: Colors.white, fontSize: 14),
              ),
            )
          ],
        ),
      );

  // 关注和取消关注
  void _followOrUnfollow(bool isFollow) {
    if (Provider.of<MyProvider>(context).getUser() == null) {
      _toastShow("请先登录再关注！");
    } else {
      APIService.instance.postService(ApiConfig.follow, parameters: {
        "userId": Provider.of<MyProvider>(context).getUser().id.toString(),
        "followerId": widget.id,
        "isFollow": isFollow
      }).then((responser) async {
        CodeEntity codeEntity = CodeEntity.fromJson(responser.data);
        if (codeEntity.success) {
          if (isFollow) {
            _toastShow("关注成功");
            _followStatust = "已关注";
          } else {
            _toastShow("取消关注成功");
            _followStatust = "未关注";
          }
          setState(() {});
        } else {
          _toastShow(codeEntity.msg);
        }
      }).catchError((onError) async {
        _toastShow(AppConfig.onErrorMsg);
      });
    }
  }

  // 文章列表
  Widget _talkItem(BuildContext context, int index) => Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _talkBeanList[index].content,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(_talkBeanList[index].picture),
              ),
            ),
          ],
        ),
      );

  // 显示提示框
  void _toastShow(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
    refreshController.dispose();
  }
}
