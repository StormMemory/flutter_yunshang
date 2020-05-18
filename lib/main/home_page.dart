import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/BannerBean.dart';
import 'package:futures/entity/BannerEntity.dart';
import 'package:futures/entity/TalkBean.dart';
import 'package:futures/entity/TalkListEntity.dart';
import 'package:futures/forum/forum_detail.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:futures/quotes/MarketPage.dart';
import 'package:futures/quotes/StockDetailsPage.dart';
import 'package:futures/api/APIService.dart';
import 'package:futures/quotes/entity/ListEnity.dart';
import 'package:futures/quotes/entity/StockIndex.dart';
import 'package:futures/web/Web.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: true);
    // _getRecommandTalk();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.appBarColor,
        title: Text(
          "主页",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
      body: _body(),
    );
  }

  RefreshController _refreshController;
  List<TalkBean> _talkList = List();
  List<StockIndex> listData = [];
  int page = 1;

  Widget _body() => Container(
        child: _refresher(),
      );

  // 刷新和加载更多控件
  Widget _refresher() => SmartRefresher(
        key: widget.key,
        controller: _refreshController,
        enablePullDown: true,
        enablePullUp: true,
        onRefresh: _onRefresh,
        onLoading: _onLoadMore,
        header: _refreshHeader(),
        footer: _refreshFooter(),
        child: SingleChildScrollView(
          child: Column(
            // direction: Axis.vertical,
            children: <Widget>[
              // _swiper(),
              _type(),
              Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                // margin: EdgeInsets.only(top: 10),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "| 热门指数",
                  style:
                      TextStyle(fontSize: 14, color: ColorConfig.appBarColor),
                ),
              ),
              _index(),
              Container(
                color: Colors.white,
                padding:
                    EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                margin: EdgeInsets.only(top: 10),
                alignment: Alignment.bottomLeft,
                child: Text(
                  "| 推荐论坛",
                  style:
                      TextStyle(fontSize: 14, color: ColorConfig.appBarColor),
                ),
              ),
              _listViewBuild()
            ],
          ),
        ),
      );

  List<BannerBean> swiperDataList = [];

  // 轮播图控件
  Widget _swiper() => swiperDataList.isNotEmpty
      ? SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 2,
          child: Swiper(
            outer: false,
            itemBuilder: _buildSwiperItem,
            pagination: SwiperPagination(
                margin: new EdgeInsets.all(5.0),
                alignment: Alignment.bottomRight,
                builder: SwiperPagination.dots),
            itemCount: swiperDataList == null ? 0 : swiperDataList.length,
            autoplay: true,
            duration: 300, //3秒轮播
          ),
        )
      : SizedBox.shrink();

  // Swiper子项
  Widget _buildSwiperItem(BuildContext context, int index) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return Web(
              url: swiperDataList[index].url,
              appBar: "头条",
            );
          }));
        },
        child: CachedNetworkImage(
          imageUrl: _getPicPath(index),
          imageBuilder: (BuildContext context, ImageProvider imageProvider) =>
              Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      Colors.transparent, BlendMode.colorBurn)),
            ),
          ),
          placeholder: _placeholderIndicator,
          placeholderFadeInDuration: const Duration(microseconds: 400),
          errorWidget: _errorWidget,
          useOldImageOnUrlChange: false,
        ),
      );
  // 地址访问不到，换其它图片
  String _getPicPath(int index) {
    String pic = "";
    switch (index) {
      case 0:
        pic =
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1571388849434&di=2f837b3b96c28edc35870460459d4de5&imgtype=jpg&src=http%3A%2F%2Fimg3.imgtn.bdimg.com%2Fit%2Fu%3D2294601923%2C3324910212%26fm%3D214%26gp%3D0.jpg";
        break;
      case 1:
        pic =
            "https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=4282599652,2708122315&fm=26&gp=0.jpg";
        break;
      case 2:
        pic =
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1571388886823&di=80c4992c6071e237f405c4e3218079ff&imgtype=0&src=http%3A%2F%2Foss.huangye88.net%2Flive%2Fueditor%2Fphp%2Fupload%2F2073597%2Fimage%2F20171216%2F1513399269362849.jpg";
        break;
      default:
        pic =
            "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1571388904406&di=3deb11f1b182aaf961d2ca03a3bcf53d&imgtype=0&src=http%3A%2F%2Ffile16.zk71.com%2FFile%2FCorpProductImages%2F2019%2F09%2F11%2Fflying190214_2_20190911104444.png";
    }
    return pic;
  }

  // 加载图片占位widget
  Widget _placeholderIndicator(BuildContext context, String url) => Center(
        child: CircularProgressIndicator(
          valueColor:
              AlwaysStoppedAnimation<Color>(ColorConfig.refreshIndicatorColor),
        ),
      );

  // 加载图片错误widget
  Widget _errorWidget(BuildContext context, String url, Object error) => Icon(
        Icons.error,
        color: ColorConfig.refreshIndicatorColor,
      );

  // 类型
  Widget _type() => Container(
        color: Colors.white,
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 5),
        child: Flex(
          direction: Axis.horizontal,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return Web(
                      url:
                          "https://www.jin10.com/example/jin10.com.html?fontSize=14px&backgroundColor=ffffff&color=000000",
                      appBar: "市场数据",
                    );
                  }));
                },
                child: Column(
                  children: <Widget>[
                    ClipOval(
                        child: Image(
                      width: 50,
                      fit: BoxFit.cover,
                      height: 50,
                      image: AssetImage("assets/images/icon_shichang.png"),
                    )),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.center,
                      child: Text("市场快讯"),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Provider.of<MyProvider>(context).updateIndex(2);
                  setState(() {});
                },
                child: Column(
                  children: <Widget>[
                    ClipOval(
                        child: Image(
                      width: 50,
                      fit: BoxFit.cover,
                      height: 50,
                      image: AssetImage("assets/images/icon_luntan.png"),
                    )),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.center,
                      child: Text("论坛中心"),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Provider.of<MyProvider>(context).updateIndex(1);
                  setState(() {});
                },
                child: Column(
                  children: <Widget>[
                    ClipOval(
                        child: Image(
                      width: 50,
                      fit: BoxFit.cover,
                      height: 50,
                      image: AssetImage("assets/images/icon_zhushu.png"),
                    )),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.center,
                      child: Text("指数中心"),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MarketPage()));
                },
                child: Column(
                  children: <Widget>[
                    ClipOval(
                        child: Image(
                      width: 50,
                      fit: BoxFit.cover,
                      height: 50,
                      image: AssetImage("assets/images/icon_hagnqing.png"),
                    )),
                    Container(
                      margin: EdgeInsets.only(top: 5),
                      alignment: Alignment.center,
                      child: Text("沪深行情"),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );

  // 指数
  Widget _index() => swiperDataList.isNotEmpty
      ? SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width / 3,
          child: getGistView(),
        )
      : SizedBox.shrink();

  // GridView
  getGistView() {
    return GridView.count(
      crossAxisCount: 3,
      padding: const EdgeInsets.all(5.0),
      //主轴间隔
      mainAxisSpacing: 0.0,
      //横轴间隔
      crossAxisSpacing: 0.0,
      children: buildGridList(),
    );
  }

  // 添加数据
  buildGridList() {
    List<Widget> widgetList = new List();
    for (StockIndex stockIndex in listData) {
      widgetList.add(getItemWidget(stockIndex));
    }
    return widgetList;
  }

  // item
  Widget getItemWidget(StockIndex stockIndex) {
    Color showColor;
    String gainsRate = stockIndex.gains_rate;
    String changePrefix = "";
    if (gainsRate == "0.00") {
      showColor = Colors.black38;
    } else {
      if (gainsRate.indexOf("-") == -1) {
        changePrefix = "+";
        showColor = Colors.red;
      } else {
        showColor = Colors.green;
      }
    }
    return new GestureDetector(
      child: Card(
        child: Container(
          padding: new EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
          child: Column(
            children: <Widget>[
              Expanded(
                child: Text(
                  stockIndex.name,
                  style: new TextStyle(fontSize: 18.0, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
                flex: 1,
              ),
              Expanded(
                child: new Text(
                  stockIndex.current_points,
                  style: new TextStyle(fontSize: 20.0, color: showColor),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
                flex: 1,
              ),
              Expanded(
                child: Container(
                  padding: new EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: Text(
                            stockIndex.current_prices,
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.blue),
                            maxLines: 1,
                          ),
                          alignment: FractionalOffset.centerLeft,
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            changePrefix + gainsRate + "%",
                            style:
                                new TextStyle(fontSize: 12.0, color: showColor),
                            maxLines: 1,
                          ),
                          alignment: FractionalOffset.centerRight,
                        ),
                        flex: 1,
                      )
                    ],
                  ),
                ),
                flex: 1,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => StockDetailsPage(
                      enity: ListEnity("index", stockIndex),
                    )));
      },
    );
  }

  // 获取数据
  void getDatas() {
    String url = "http://hq.sinajs.cn/list=s_sh000002,s_sh000003,s_sh000300";
    fetch(url).then((data) {
      setState(() {
        List<String> indexStrs = data.split(";");
        setState(() {
          listData.clear();
          for (int i = 0; i < (indexStrs.length - 1); i++) {
            String str = indexStrs[i];
            StockIndex stockIndex = new StockIndex();
            DealStockIndess(str, stockIndex);
            listData.add(stockIndex);
          }
        });
      });
    }).catchError((e) {
      _showToast(AppConfig.onErrorMsg);
    });
  }

  // ���理指数数据
  Future DealStockIndess(String str, StockIndex stockIndex) async {
    int start = str.indexOf("\"") + 1;
    int end = str.indexOf("\"", start);

    stockIndex.stock_code2 = str.substring(str.indexOf("_s_") + 3, start - 2);
    stockIndex.stock_code = str.substring(str.indexOf("_s_") + 5, start - 2);

    List indexItem = str.substring(start, end).split(",");
    stockIndex.name = indexItem[0];
    stockIndex.current_points = indexItem[1];
    stockIndex.current_prices = indexItem[2];
    stockIndex.gains_rate = indexItem[3];
    stockIndex.traded_num = indexItem[4];
    stockIndex.traded_amount = indexItem[5];
  }

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk(response.bodyBytes);
    return str;
  }

  // listview
  Widget _listViewBuild() => CustomScrollView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  _talkList.isNotEmpty
                      ? ListView.separated(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _talkList.length,
                          itemBuilder: _item,
                          separatorBuilder: (BuildContext context, int index) {
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
      );

  // 刷新控件Header
  Widget _refreshHeader() => WaterDropHeader(
        waterDropColor: ColorConfig.refreshIndicatorColor,
      );

  // 刷新控件Footer
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

  // 刷新
  _onRefresh() {
    page = 1;
    _getRecommandTalk();
    getDatas();
    getBannerList();
  }

  getBannerList() {
    APIService.instance.getService(ApiConfig.getBannerList,
        queryParameters: {"project": AppConfig.project}).then((response) async {
      BannerEntity bannerEntity = BannerEntity.fromJson(response.data);
      if (bannerEntity.success) {
        swiperDataList.clear();
        swiperDataList.addAll(bannerEntity.list);
      }
    }).catchError((onError) async {});
  }

  // 加载更多
  _onLoadMore() {
    page++;
    _getRecommandTalk();
  }

  // item
  Widget _item(BuildContext context, int index) => GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            return ForumDetail(
              talkBean: _talkList[index],
            );
          }));
        },
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
          // margin: EdgeInsets.only(top: 5),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.end,
            direction: Axis.horizontal,
            children: <Widget>[
              _getPic(_talkList[index].picture),
              Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 10, right: 10, top: 2),
                  alignment: Alignment.bottomLeft,
                  child: Flex(
                    direction: Axis.vertical,
                    children: <Widget>[
                      Text(
                        _talkList[index].content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 14),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        alignment: Alignment.bottomLeft,
                        child: Text(
                          _timeToDate(_talkList[index].publishTime) +
                              "  发表于：  " +
                              _talkList[index].user.nickName,
                          style: TextStyle(fontSize: 12, color: Colors.black45),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      );

  // 获取推荐动态
  _getRecommandTalk() {
    APIService.instance.getService(ApiConfig.getRecommandTalk, queryParameters: {
      "project": AppConfig.project,
      "userId": Provider.of<MyProvider>(context).getUser() == null
          ? ""
          : Provider.of<MyProvider>(context).getUser().id,
      "pageNumber": page,
      "pageSize": 10
    }).then((response) async {
      TalkListEntity talkListEntity = TalkListEntity.fromJson(response.data);
      if (talkListEntity.success &&
          talkListEntity.data != null &&
          talkListEntity.data.list != null &&
          talkListEntity.data.list.length > 0) {
        if (page == 1) {
          _talkList.clear();
        }
        _talkList.addAll(talkListEntity.data.list);
        _refreshController.loadComplete();
      } else {
        _refreshController.loadNoData();
      }
      _refreshController.refreshCompleted();
      setState(() {});
    }).catchError((onError) async {
      _showToast(AppConfig.onErrorMsg);
      _refreshController.loadFailed();
      _refreshController.refreshCompleted();
      setState(() {});
    });
  }

  // 毫秒转换为日期格式
  String _timeToDate(int milliseconds) {
    return DateUtil.getDateStrByMs(milliseconds,
        format: DateFormat.YEAR_MONTH_DAY);
  }

  Widget _getPic(String pic) {
    // DateUtil.getDateStrByMs(1562484092000);

    if (pic.isEmpty) {
      return Text("");
    } else {
      List<String> _picList = pic.split(",");
      return ClipRRect(
        borderRadius: BorderRadius.circular(6.0),
        child: Image(
          width: 100,
          height: 100,
          // color: ColorConfig.appBarColor,
          image: NetworkImage(_picList[0]),
          fit: BoxFit.cover,
        ),
      );
    }
  }

  // 显示提示框
  _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }
}
