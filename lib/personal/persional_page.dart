import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/UserBean.dart';
import 'package:futures/notification/notification_page.dart';
import 'package:futures/personal/feedback.dart';
import 'package:futures/personal/persional_dynamic.dart';
import 'package:futures/personal/persional_relation.dart';
import 'package:futures/personal/personal_center.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:futures/station/Login.dart';
import 'package:futures/station/Register.dart';
import 'package:futures/web/Web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersionalPage extends StatefulWidget {
  PersionalPage({Key key}) : super(key: key);

  @override
  _PersionalPageState createState() => _PersionalPageState();
}

class _PersionalPageState extends State<PersionalPage> {
  @override
  void initState() {
    super.initState();
    // Provider.of<MyProvider>(context).getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(247, 247, 247, 1),
      body: _body(),
    );
  }

  Widget _body() => SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // 个人中心
            _userInfo(),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                leading: Image.asset("assets/images/ic_reset_password.png"),
                onTap: _resetPassword,
                title: Text("修改密码"),
              ),
            ),
            Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 20),
              child: ListTile(
                leading: Image.asset("assets/images/ic_feedback.png"),
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return FeedBack();
                  }));
                },
                title: Text("意见反馈"),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Image.asset("assets/images/ic_user_protocol.png"),
                // leading: Icon(Icons.home),
                onTap: () {
                  // 关于我们
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return Web(
                      url: ApiConfig.agreement,
                      appBar: "用户协议",
                    );
                  }));
                },
                title: Text("用户协议"),
              ),
            ),
            Container(
              color: Colors.white,
              child: ListTile(
                leading: Image.asset("assets/images/ic_login_out.png"),
                // leading: Icon(Icons.home),
                onTap: _loginOut,
                title: Text("退出登录"),
              ),
            )
          ],
        ),
      );

  // 个人中心相关内容
  Widget _userInfo() => Stack(
        alignment: Alignment.center,
        children: <Widget>[
          ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: double.infinity, minHeight: 60),
            child: Image.asset(
              "assets/images/mine_bg.png",
              color: ColorConfig.appBarColor,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 20, right: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  onTap: _personalCenter,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      //圆形头像
                      GestureDetector(
                        onTap: _personalCenter,
                        child: Container(
                          width: 79,
                          height: 79,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(_headPic()))),
                        ),
                      ),
                      //昵称和签名
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                _nickName(),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              child: Text(
                                _signature(),
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 14),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                //消息按钮
                Container(
                  alignment: Alignment.topRight,
                  width: 30,
                  height: 30,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => NotificationPage()));
                    },
                    child: Image.asset(
                      "assets/images/bar_notice_selecet.png",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: _relationshipWidget(),
          )
        ],
      );

  // 头像地址
  String _headPic() => Provider.of<MyProvider>(context).getUser() == null
      ? AppConfig.defaultPic
      : Provider.of<MyProvider>(context).getUser().head;

  // 昵称
  String _nickName() => Provider.of<MyProvider>(context).getUser() == null
      ? "未登录"
      : Provider.of<MyProvider>(context).getUser().nickName;

  String _signature() =>
      Provider.of<MyProvider>(context).getUser() == null
          ? "登录过后更精彩！"
          : Provider.of<MyProvider>(context).getUser().signature;

  // 关注，粉丝，动态
  Widget _relationshipWidget() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _relationshipItem(_followTap, "关注", _followCount()),
          _relationshipItem(_fansTap, "粉丝", _fansCount()),
          _relationshipItem(_talkTap, "动态", _talkCount()),
        ],
      );

  // 关注，粉丝，动态子控件
  Widget _relationshipItem(
    Function _tap,
    String _itemName,
    String _itemNum,
  ) =>
      GestureDetector(
        onTap: _tap,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _itemNum,
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              Container(
                padding: EdgeInsets.only(top: 12, bottom: 0),
                child: Text(
                  _itemName,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              )
            ],
          ),
        ),
      );

  // 关注点击事件
  void _followTap() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Provider.of<MyProvider>(context).getUser() == null
          ? Login()
          : PersionalRelation(
              type: 1,
            );
    }));
  }

  String _followCount() => Provider.of<MyProvider>(context).getUser() ==
          null
      ? "0"
      : Provider.of<MyProvider>(context).getUser().followCount.toString();

  // 粉丝点击事件
  void _fansTap() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Provider.of<MyProvider>(context).getUser() == null
          ? Login()
          : PersionalRelation(
              type: 2,
            );
    }));
  }

  String _fansCount() => Provider.of<MyProvider>(context).getUser() ==
          null
      ? "0"
      : Provider.of<MyProvider>(context).getUser().fansCount.toString();

  // 动态点击事件
  void _talkTap() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Provider.of<MyProvider>(context).getUser() == null
          ? Login()
          : PersionalDynamic();
    }));
  }

  String _talkCount() => Provider.of<MyProvider>(context).getUser() ==
          null
      ? "0"
      : Provider.of<MyProvider>(context).getUser().talkCount.toString();

  // 跳转个人中心或者登陆界面
  void _personalCenter() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      return Provider.of<MyProvider>(context).getUser() == null
          ? Login()
          : PersionalCenter();
    }));
  }

  // 退出登录
  void _loginOut() {
    if (Provider.of<MyProvider>(context).getUser() != null) {
      showCupertinoDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              title: Text('系统提示'),
              content: Text("是否退出登录？"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    '取消',
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                FlatButton(
                  child: Text('确定', style: TextStyle(color: Colors.black)),
                  onPressed: () async {
                    Provider.of<MyProvider>(context).removeUser();
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            );
          });
    }
  }

  // 修改密码点击事件
  void _resetPassword() {
    if (Provider.of<MyProvider>(context).getUser() == null) {
      _showToast("当前未登录账户！");
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return Register(
          type: 3,
        );
      }));
    }
  }

  // 显示提示框
  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }

  _savedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("id") != null) {
      // 有数据
      UserBean user = UserBean()
        ..uuid = prefs.getString("uuid")
        ..id = prefs.getInt("id")
        ..phone = prefs.getString("phone")
        ..password = prefs.getString("password")
        ..head = prefs.getString("head")
        ..album = prefs.getString("album")
        ..nickName = prefs.getString("nickName")
        ..signature = prefs.getString("signature")
        ..type = prefs.getInt("type")
        ..projectKey = prefs.getString("projectKey")
        ..talkCount = prefs.getInt("talkCount")
        ..followCount = prefs.getInt("followCount")
        ..fansCount = prefs.getInt("fansCount");
      Provider.of<MyProvider>(context).addUser(user);
    }
  }
}
