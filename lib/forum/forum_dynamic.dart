import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/TalkBean.dart';
import 'package:futures/entity/TalkListEntity.dart';

import 'package:futures/api/APIService.dart';
import 'package:futures/forum/forum_detail.dart';
import 'package:futures/personal/persional_information.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// 根据类型请求动态
class ForumDynamic extends StatefulWidget {
  ForumDynamic({Key key, this.index}) : super(key: key);

  final int index;
  @override
  _ForumDynamicState createState() => _ForumDynamicState();
}

class _ForumDynamicState extends State<ForumDynamic> {
  RefreshController refreshController;
  int page = 1;
  List<TalkBean> _talkList = List();

  @override
  void initState() {
    super.initState();
    refreshController = RefreshController(initialRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      enablePullUp: true,
      onRefresh: refresh,
      onLoading: loadMore,
      header: refreshView(),
      footer: lodeMoreView(),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _items(_talkList[index]);
        },
        itemCount: _talkList.length,
      ),
    );
  }

  // 刷新显示的头部控件
  Widget refreshView() => WaterDropHeader(
        waterDropColor: ColorConfig.refreshIndicatorColor,
      );

  // 加载更多时显示的控件
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

  // 刷新
  refresh() {
    page = 1;
    getTalkList();
  }

  // 加载更多
  loadMore() {
    page++;
    getTalkList();
  }

  getTalkList() {
    String userId = Provider.of<MyProvider>(context).getUser() == null
        ? "0"
        : Provider.of<MyProvider>(context).getUser().id.toString();
    var data;
    switch (widget.index) {
      case 1: //关注
        data = {"_orderBy": "publishTime", "_pageNumber": page};
        break;
      // case 2: //最新
      //   data = {"_orderBy": "publishTime", "_pageNumber": page};
      //   break;
      case 2: //热门
        data = {"_orderByDesc": "commentCount", "_pageNumber": page};
        break;
      default:
    }

    APIService.instance
        .postService(ApiConfig.getTalkList + userId, data: data)
        .then((response) async {
      TalkListEntity talkListEntity = TalkListEntity.fromJson(response.data);
      if (talkListEntity.success &&
          talkListEntity.data != null &&
          talkListEntity.data.list != null &&
          talkListEntity.data.list.length > 0) {
        if (page == 1) {
          _talkList.clear();
        }
        _talkList.addAll(talkListEntity.data.list);
        refreshController.loadComplete();
      } else {
        refreshController.loadNoData();
      }
      refreshController.refreshCompleted();
      setState(() {});
    }).catchError((onError) {
      toastShow(AppConfig.onErrorMsg);
      refreshController.loadFailed();
      refreshController.refreshCompleted();
      setState(() {});
    });
  }

  toastShow(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }

  // 列表子控件
  Widget _items(TalkBean talkBean) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return ForumDetail(
              talkBean: talkBean,
            );
          }));
        },
        child: Container(
          color: Colors.white,
          margin: EdgeInsets.only(top: 5),
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                      return ForumDetail(
                        talkBean: talkBean,
                      );
                    }));
                  },
                  title: Text(
                    talkBean.user.nickName,
                    style:
                        TextStyle(color: ColorConfig.appBarColor, fontSize: 16),
                  ),
                  subtitle: Container(
                    child: Text(
                      talkBean.user.signature.isEmpty
                          ? "该用户很懒，什么都没留下！"
                          : talkBean.user.signature,
                      style: TextStyle(color: Colors.black54, fontSize: 10),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  leading: GestureDetector(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return PersionalInformation(
                          id: talkBean.user.id,
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
                              image: NetworkImage(talkBean.user.head))),
                    ),
                  ),
                ),
              ),
              Container(
                decoration: new BoxDecoration(
                  //背景
                  color: Color.fromRGBO(235, 235, 235, 1),
                  //设置四周圆角 角度
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  //设置四周边框
                  // border: new Border.all(
                  //     width: 1, color: Color.fromRGBO(235, 235, 235, 1)),
                ),
                margin: EdgeInsets.only(left: 70, right: 20),
                padding: EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
                child: Column(
                  children: <Widget>[
                    Text(
                      talkBean.content,
                      maxLines: 3,
                    ),
                    getPic(talkBean.picture),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(
                  right: 20,
                  top: 10,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Icon(
                      Icons.star,
                      size: 22,
                      color: Colors.black26,
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        left: 10,
                      ),
                      child: Text(
                        talkBean.zanCount.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Icon(
                        Icons.mode_edit,
                        size: 20,
                        color: Colors.black26,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text(
                        talkBean.commentCount.toString(),
                        style: TextStyle(fontSize: 14, color: Colors.black54),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );

  Widget getPic(String pic) {
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
}
