import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:futures/station/Login.dart';
import 'package:provider/provider.dart';
import 'notification_interactive.dart';
import 'notification_system.dart';

class NotificationPage extends StatefulWidget {
  NotificationPage({Key key}) : super(key: key);

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.appBarColor,
        elevation: 0,
        title: Text(
          "通知",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      body: _notification(),
    );
  }

  Widget _notification() => Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10),
            color: Colors.white,
            child: ListTile(
              onTap: () {
                // 跳转系统消息详情页面
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return System();
                }));
              },
              contentPadding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/icon_tongzhi.png"))),
              ),
              title: Text(
                "系统通知",
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "欢迎登录本APP，APP中遇到任何问题可在我的页面-意见反馈中...",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ),
          Divider(
            height: 1,
            indent: 68,
            color: Color.fromRGBO(225, 225, 225, 1),
          ),
          Container(
            color: Colors.white,
            child: ListTile(
              onTap: () {
                // 跳转系统消息详情页面
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return Provider.of<MyProvider>(context).getUser() == null
                      ? Login()
                      : Interactive();
                }));
              },
              contentPadding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 10, right: 10),
              leading: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/icon_xiaoxi.png"))),
              ),
              title: Text(
                "互动通知",
                style: TextStyle(fontSize: 16),
              ),
              subtitle: Container(
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "点击查看互动消息",
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          )
        ],
      );
}
