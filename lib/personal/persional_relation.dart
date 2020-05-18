import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/CodeEntity.dart';
import 'package:futures/entity/RelationshipEntity.dart';
import 'package:futures/entity/UserBean.dart';
import 'package:futures/api/APIService.dart';
import 'package:futures/personal/persional_information.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class PersionalRelation extends StatefulWidget {
  PersionalRelation({Key key, this.type}) : super(key: key);
  final int type;
  @override
  _PersionalRelationState createState() => _PersionalRelationState();
}

class _PersionalRelationState extends State<PersionalRelation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.type == 1 ? "关注列表" : "粉丝列表",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: ColorConfig.appBarColor,
      ),
      body: _body(),
    );
  }

  RefreshController _refreshController;

  int page = 1;
  List<UserBean> _list = List();

  // 主体布局
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
    _getRelationshipList();
  }

  // 加载更多
  void _onLoadMore() {
    page++;
    _getRelationshipList();
  }

  void _getRelationshipList() {
    APIService.instance.getService(ApiConfig.getUserFollowList, queryParameters: {
      'userId': Provider.of<MyProvider>(context).getUser().id.toString(),
      'type': widget.type,
      'pageNumber': page,
      'pageSize': 10
    }).then((response) {
      RelationshipEntity relationshipEntity =
          RelationshipEntity.fromJson(response.data);
      if (relationshipEntity.success &&
          relationshipEntity.data != null &&
          relationshipEntity.data.list != null &&
          relationshipEntity.data.list.length > 0) {
        if (page == 1) {
          _list.clear();
        }
        _list.addAll(relationshipEntity.data.list);
        _refreshController.refreshCompleted();
        setState(() {});
      } else {
        _refreshController.loadNoData();
        setState(() {});
      }
    }).catchError((errorMsg) {
      // _showToast("当前网络较差，请稍后重试。");
      print("object1");
      _refreshController.loadFailed();
      setState(() {});
    });
  }

  // 列表子控件
  Widget _items(UserBean userBean) => Column(
        children: <Widget>[
          ListTile(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                return PersionalInformation(
                  id: userBean.id,
                );
              }));
            },
            contentPadding:
                EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10),
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover, image: NetworkImage(userBean.head))),
            ),
            title: Text(
              userBean.nickName,
              style: TextStyle(color: ColorConfig.appBarColor, fontSize: 15),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 3, bottom: 6),
                  child: Text(
                    userBean.signature,
                    style: TextStyle(
                        fontSize: 9, color: Color.fromRGBO(102, 102, 102, 1)),
                  ),
                ),
                Text(
                  "动态 ${userBean.talkCount}  粉丝 ${userBean.fansCount}",
                  style: TextStyle(
                      fontSize: 11, color: Color.fromRGBO(51, 51, 51, 1)),
                )
              ],
            ),
            trailing: widget.type == 1
                ? MaterialButton(
                    shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                    color: ColorConfig.appBarColor,
                    elevation: 0,
                    child: Text("取消关注",
                        style: TextStyle(color: Colors.white, fontSize: 12)),
                    onPressed: () {
                      _unsubscribe(userBean.id);
                    },
                  )
                : Text(""),
          ),
          Divider(
            height: 1,
            color: Color.fromRGBO(225, 225, 225, 1),
          )
        ],
      );
  // 取消关注
  void _unsubscribe(int id) {
    APIService.instance.postService(ApiConfig.follow, parameters: {
      "userId": Provider.of<MyProvider>(context).getUser().id.toString(),
      "followerId": id,
      "isFollow": false
    }).then((responser) async {
      CodeEntity codeEntity = CodeEntity.fromJson(responser.data);
      if (codeEntity.success) {
        showToast("取消关注成功");
        page = 1;
        _getRelationshipList();
      } else {
        showToast(codeEntity.msg);
      }
    }).catchError((onError) async {
      showToast(AppConfig.onErrorMsg);
    });
  }

  // 显示提示框
  void showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
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

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }
}
