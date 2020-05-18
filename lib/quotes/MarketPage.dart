
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/quotes/compute_util.dart';
import 'package:futures/quotes/entity/DataUtils.dart';
import 'package:futures/quotes/entity/ListEnity.dart';
import 'package:http/http.dart' as http;
import 'package:gbk2utf8/gbk2utf8.dart';

import 'StockDetailsPage.dart';
import 'entity/Stock.dart';

class MarketPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new MarketPageState();
}

class MarketPageState extends State<MarketPage> {
  List<Stock> stocks = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.appBarColor,
        title: Text(
          "沪深详情",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: getBody(),
    );
    // return new Center(child: getBody());
  }

  @override
  void initState() {
    getDatas();
  }

  void getDatas() {
    stocks.clear();
    stocks.add(new Stock());
    String url =
        "http://hq.sinajs.cn/list=sh601003,sh601001,sz002242,sz002230,sh603456,sz002736,sh600570,sz002456,sz000416,"+
        "sh600519,sz000001,sh601857,sz000333,sz000002,sz000651,sz002415,sz000651,sz300033,sh688010,sh688028,sh688009,"+
        "sh688012,sz300143,sz300143,sz002949,sz000012,sz300684,sz200613,sh900917,sz002448,sh600648,sz002351,sz300072";
    fetch(url).then((data) {
      setState(() {
        List<String> stockstrs = data.split(";");
        setState(() {
          for (int i = 0; i < (stockstrs.length - 1); i++) {
            String str = stockstrs[i];
            Stock stock = new Stock();
            stocks.add(DealStocks(str, stock));
          }
          // if (request_type == REFRESH_REQIEST) {
          //   Fluttertoast.showToast(
          //       msg: "刷新成功",
          //       toastLength: Toast.LENGTH_SHORT,
          //       gravity: ToastGravity.BOTTOM,
          //       timeInSecForIos: 1,
          //       backgroundColor: Colors.black,
          //       textColor: Colors.white);
          // }
        });
      });
    }).catchError((e) {
      Fluttertoast.showToast(
          msg: "网络异常，请检查",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white);
    });
  }

  Future fetch(String url) async {
    http.Response response = await http.get(url);
    String str = decodeGbk(response.bodyBytes);
    return str;
  }



  getBody() {
    if (stocks.isEmpty) {
      // 加载菊花
      return CircularProgressIndicator();
    } else {
      return new Container(
        child: new RefreshIndicator(
            child: getListView(), onRefresh: pullToRefresh),
        alignment: FractionalOffset.topLeft,
      );
    }
  }

  getListView() {
    return ListView.builder(
      itemCount: (stocks == null) ? 0 : stocks.length,
      itemBuilder: (BuildContext context, int position) {
        return getItem(position);
      },
      physics: new AlwaysScrollableScrollPhysics(),
      shrinkWrap: true,
    );
  }

  getItem(int position) {
    if (position == 0) {
      return TopWidget();
    } else {
      return getListViewItem(position);
    }
  }

  /**
   *显示涨幅
   */
  ShowGains(double gains) {
    Color show_color;
    String gains_str = (gains * 100).toStringAsFixed(2) + "%";
    if (gains > 0) {
      show_color = Colors.red;
      gains_str = "+" + gains_str;
    } else if (gains < 0) {
      show_color = Colors.green;
    } else {
      show_color = Colors.black38;
    }
    return new Container(
      color: show_color,
      padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
      child: new Text(
        gains_str,
        style: new TextStyle(fontSize: 18.0, color: Colors.white),
      ),
      alignment: FractionalOffset.center,
    );
  }

  Future<Null> pullToRefresh() async {
    getDatas();
    return null;
  }

  /**
   * 顶部布局
   */
  TopWidget() {
    return new Container(
      height: 30.0,
      child: new Padding(
        padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Container(
                child: new Text(
                  "股票名称",
                  style: new TextStyle(fontSize: 14.0, color: Colors.black26),
                ),
                alignment: FractionalOffset.center,
              ),
              flex: 8,
            ),
            new Expanded(
              child: new Container(
                child: new Text(
                  "最新价",
                  style: new TextStyle(fontSize: 14.0, color: Colors.black26),
                ),
                alignment: FractionalOffset.center,
              ),
              flex: 13,
            ),
            new Expanded(
              child: new Container(
                padding: new EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
                child: new Text(
                  "涨跌幅",
                  style: new TextStyle(fontSize: 14.0, color: Colors.black26),
                ),
                alignment: FractionalOffset.center,
              ),
              flex: 9,
            ),
          ],
        ),
      ),
    );
  }

  getListViewItem(int position) {
    Stock stock = stocks[position];
    double yesterday_close = double.parse(stock.yesterday_close);
    double current_prices = double.parse(stock.current_prices);
    double today_open = double.parse(stock.today_open);
    double gains = ComputeGainsRate(yesterday_close, current_prices, today_open);
    stocks[position].gains=gains;
    String current_prices_str = current_prices.toStringAsFixed(2);
    return new GestureDetector(
      child: new Card(
        child: new Padding(
          padding: new EdgeInsets.fromLTRB(0.0, 5.0, 10.0, 5.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new Container(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    //纵向对齐方式：起始边对齐
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new Container(
                        child: new Text(
                          stock.name,
                          style: new TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.w700),
                        ),
                        alignment: FractionalOffset.topCenter,
                      ),
                      new Container(
                        child: new Text(
                          stock.stock_code,
                          style: new TextStyle(
                              fontSize: 12.0, color: Colors.black38),
                        ),
                        alignment: FractionalOffset.bottomCenter,
                      )
                    ],
                  ),
                ),
                flex: 1,
              ),
              new Expanded(
                child: new Container(
                  child: new Text(
                    current_prices_str,
                    style: new TextStyle(fontSize: 18.0),
                  ),
                  alignment: FractionalOffset.center,
                ),
                flex: 2,
              ),
              new Expanded(
                child: ShowGains(gains),
                flex: 1,
              )
            ],
          ),
        ),
      ),
      onTap: () {
        onItimeClick(stock);
      },
    );
  }

  /**
   * 列表点击
   */
  void onItimeClick(Stock stock) {
    Navigator.push(context, new MaterialPageRoute(builder: (context)=>  StockDetailsPage(enity: ListEnity("stock",stock))));
  }
}
