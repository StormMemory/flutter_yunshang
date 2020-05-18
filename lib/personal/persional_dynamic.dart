import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/TalkBean.dart';
import 'package:futures/entity/TalkListEntity.dart';
import 'package:futures/api/APIService.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// 动态列表
class PersionalDynamic extends StatefulWidget {
  @override
  _PersionalDynamicState createState() => _PersionalDynamicState();
}

class _PersionalDynamicState extends State<PersionalDynamic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(245, 245, 245, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConfig.appBarColor,
        title: Text(
          "我的动态",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: _body(),
    );
  }

  RefreshController _refreshController;
  int page = 1;
  List<TalkBean> _list = List();

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
    _getDynamicList();
  }

  // 加载更多
  void _onLoadMore() {
    page++;
    _getDynamicList();
  }

  // 列表子控件
  Widget _items(TalkBean talkBean) => Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              talkBean.content,
              maxLines: 3,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(talkBean.picture),
              ),
            ),
          ],
        ),
      );

  // 获取我的动态数据
  void _getDynamicList() {
    APIService.instance.postService(
        ApiConfig.getTalkList +
            Provider.of<MyProvider>(context).getUser().id.toString(),
        data: {
          "userId": Provider.of<MyProvider>(context).getUser().id.toString(),
          "_orderBy": "publishTime",
          "_pageNumber": page
        }).then((response) async {
      TalkListEntity talkListEntity = TalkListEntity.fromJson(response.data);
      if (talkListEntity.success &&
          talkListEntity.data != null &&
          talkListEntity.data.list != null &&
          talkListEntity.data.list.length > 0) {
        if (page == 1) {
          _list.clear();
        }
        _list.addAll(talkListEntity.data.list);
        _refreshController.refreshCompleted();
        setState(() {});
      } else {
        _refreshController.loadNoData();
        setState(() {});
      }
    }).catchError((onError) {
      _showToast("当前网络较差，请稍后重试。");
      _refreshController.loadFailed();
      setState(() {});
    });
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

  // 显示提示信息
  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }
  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }
}
