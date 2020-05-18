import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/InteractiveBean.dart';
import 'package:futures/entity/InteractiveEntity.dart';
import 'package:futures/api/APIService.dart';
import 'package:futures/personal/persional_information.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class Interactive extends StatefulWidget {
  @override
  _InteractiveState createState() => _InteractiveState();
}

class _InteractiveState extends State<Interactive> {
  @override
  Widget build(BuildContext context) {
    // getUserTalkByUserId();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.appBarColor,
        elevation: 0,
        title: Text(
          "互动消息",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: _body(),
    );
  }

  RefreshController _refreshController;
  int page = 1;
  List<InteractiveBean> _list = List();

  Widget _body() => SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoadMore,
        header: _refreshHeader(),
        footer: _refreshFooter(),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return _items(_list[index]);
          },
          itemCount: _list.length,
        ),
      );

  // 刷新
  void _onRefresh() {
    page = 1;
    getUserTalkByUserId();
  }

  // 加载更多
  void _onLoadMore() {
    page++;
    getUserTalkByUserId();
  }

  // 刷新显示的头部控件
  Widget _refreshHeader() => WaterDropHeader(
        waterDropColor: ColorConfig.refreshIndicatorColor,
      );

  // 加载更多时显示的控件
  Widget _refreshFooter() => CustomFooter(
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

  // 列表子控件
  Widget _items(InteractiveBean bean) => Column(
        children: <Widget>[
          Container(
            child: ListTile(
              onTap: () {
                print("跳转动态详情页面");
              },
              contentPadding: EdgeInsets.all(10),
              title: Text(
                bean.user.nickName,
                style: TextStyle(color: ColorConfig.appBarColor, fontSize: 16),
              ),
              subtitle: Container(
                margin: EdgeInsets.only(top: 12),
                child: Text(getType(bean.type) + "了你的动态",
                    style: TextStyle(color: Colors.black54, fontSize: 14)),
              ),
              leading: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return PersionalInformation(
                      id: bean.userId,
                    );
                  }));
                },
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(bean.user.head))),
                ),
              ),
              trailing: Container(
                padding: EdgeInsets.only(left: 5, right: 5, top: 2, bottom: 2),
                color: Color.fromRGBO(220, 220, 220, 1),
                width: 160,
                child: Text(bean.talkBean.content.toString(),
                    maxLines: 3,
                    style: TextStyle(color: Colors.black45, fontSize: 12)),
              ),
            ),
          ),
          Divider(
            height: 1,
            color: Color.fromRGBO(225, 225, 225, 1),
          )
        ],
      );

  String getType(int type) {
    switch (type) {
      case 1:
        return "评论";
      // case 2:
      default:
        return "点赞";
    }
  }

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  // 获取互动消息
  void getUserTalkByUserId() {
    APIService.instance.getService(ApiConfig.getUserTalkByUserId, queryParameters: {
      "userId": Provider.of<MyProvider>(context).getUser().id,
      "pageNumber": page
    }).then((response) async {
      InteractiveEntity interactiveEntity =
          InteractiveEntity.fromJson(response.data);
      if (interactiveEntity.success &&
          interactiveEntity.data.list != null &&
          interactiveEntity.data.list.length > 0) {
        if (page == 1) {
          _list.clear();
        }
        _list.addAll(interactiveEntity.data.list);
        if (interactiveEntity.data.list.length < 10) {
          _refreshController.loadNoData();
        } else {
          _refreshController.loadComplete();
        }
      } else {
        _refreshController.loadNoData();
      }
      _refreshController.refreshCompleted();
      setState(() {});
    }).catchError((onError) async {
      _refreshController.loadFailed();
      _refreshController.refreshCompleted();
      setState(() {});
      showToast(AppConfig.onErrorMsg);
    });
  }

  // 显示提示框
  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }
}
