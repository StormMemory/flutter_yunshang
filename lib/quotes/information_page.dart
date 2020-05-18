import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/quotes/entity/ListEnity.dart';
import 'package:futures/quotes/entity/StockIndex.dart';
import 'package:http/http.dart' as http;
import 'package:futures/app/ColorConfig.dart';
import 'package:gbk2utf8/gbk2utf8.dart';
import 'MarketPage.dart';
import 'StockDetailsPage.dart';

class InformationPage extends StatefulWidget {
  InformationPage({Key key}) : super(key: key);

  @override
  _InformationPageState createState() => _InformationPageState();
}

class _InformationPageState extends State<InformationPage> {
  List<StockIndex> listData = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.appBarColor,
        title: Text(
          "指数",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MarketPage()));
              },
              child: Text("沪深",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  )),
            ),
          )
        ],
      ),
      body: Container(
        child: RefreshIndicator(
          child: getGistView(),
          onRefresh: pullToRefresh,
        ),
        alignment: FractionalOffset.topLeft,
      ),
    );
  }

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

  Future<Null> pullToRefresh() async {
    getDatas();
    return null;
  }

  // 获取数据
  void getDatas() {
    String url =
        "http://hq.sinajs.cn/list=s_sz399001,s_sh000002,s_sh000003,s_sh000004,s_sh000005,s_sh000008,s_sh000009,s_sh000010,s_sh000011,s_sh000012,s_sh000016,"
        "s_sh000017,s_sh000300,s_sh000905,s_sz399002,s_sz399003,s_sz399004,s_sz399005,s_sz399006,s_sz399008,s_sz399100,"
        "s_sz399101,s_sz399106,s_sz399107,s_sz399108,s_sz399333,s_sz399606";
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

  // 处理指数数据
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
                flex: 1,
                child: new Text(
                  stockIndex.current_points,
                  style: new TextStyle(fontSize: 20.0, color: showColor),
                  maxLines: 1,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: new EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            stockIndex.current_prices,
                            style: new TextStyle(
                                fontSize: 12.0, color: Colors.blue),
                            maxLines: 1,
                          ),
                          alignment: FractionalOffset.centerLeft,
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          child: Text(
                            changePrefix + gainsRate + "%",
                            style:
                                new TextStyle(fontSize: 12.0, color: showColor),
                            maxLines: 1,
                          ),
                          alignment: FractionalOffset.centerRight,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        onItimeClick(stockIndex);
      },
    );
  }

  // 跳转至详情页面
  void onItimeClick(StockIndex stockIndex) {
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => StockDetailsPage(
                  enity: ListEnity("index", stockIndex),
                )));
  }

  // 显示提示框
  _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white);
  }

  @override
  void initState() {
    super.initState();
    getDatas();
  }
}
