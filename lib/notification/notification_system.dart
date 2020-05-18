import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futures/app/ColorConfig.dart';

// 系统消息
class System extends StatefulWidget {
  @override
  _SystemState createState() => _SystemState();
}

class _SystemState extends State<System> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.appBarColor,
        title: Text("系统消息",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            )),
      ),
      body: _body(),
    );
  }

  // 主体布局
  Widget _body() => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Flex(
            direction: Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: NetworkImage(
                            "http://b-ssl.duitang.com/uploads/item/201612/08/20161208204750_rS8N4.jpeg"))),
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  margin: EdgeInsets.only(left: 10),
                  padding:
                      EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                  decoration: BoxDecoration(
                    //背景
                    color: ColorConfig.appBarColor,
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(20.0),
                      topLeft: Radius.circular(20.0),
                    ),
                  ),
                  child: Text(
                    "欢迎登录本APP，APP中遇到任何问题可在我的页面-意见反馈中向我们提起反馈。本APP致力于创建一个股票期货资讯社区，用户可在本APP中查看资讯，发布和评论用户的见解，查看行情和指数。请在APP中遵守国家法律法规，违反者我们将封号处理。",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      );
}
