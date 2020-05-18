import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/UserBean.dart';
import 'package:futures/entity/UserEntity.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:futures/station/Register.dart';
import 'package:futures/api/APIService.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset("assets/images/ic_shut_down.png"),
          )
        ],
      ),
      body: _body(),
    );
  }

  TextEditingController _honeController = TextEditingController();
  TextEditingController _pwdeController = TextEditingController();

  Widget _body() => SingleChildScrollView(
        padding: EdgeInsets.only(left: 37, right: 37, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "账号登录",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontStyle: FontStyle.normal),
            ),
            Container(
              margin: EdgeInsets.only(top: 66),
              child: Text(
                "账号",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontStyle: FontStyle.normal),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                maxLines: 1, //最大行数
                maxLength: 11, //最大长度
                controller: _honeController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(hintText: "请输入你的账号"),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Text(
                "密码",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontStyle: FontStyle.normal),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: TextField(
                maxLines: 1,
                controller: _pwdeController,
                maxLength: 16,
                decoration: InputDecoration(hintText: "请输入你的密码"),
                obscureText: true,
              ),
            ),
            GestureDetector(
              onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return Register(type: 2,);
                  }));
              },
              child: Text(
                "忘记密码？",
                style: TextStyle(
                    color: ColorConfig.appBarColor, fontSize: 12),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40, left: 30, right: 30),
              child: MaterialButton(
                padding: EdgeInsets.only(top: 3, bottom: 3),
                shape: RoundedRectangleBorder(
                    side: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                minWidth: double.infinity,
                elevation: 1,
                color: ColorConfig.appBarColor,
                onPressed: _login,
                child: Text(
                  "登录",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                    return Register(type: 1,);
                  }));
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("还没有账号？"),
                    Text(
                      "立即注册",
                      style: TextStyle(color: ColorConfig.appBarColor),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  // 登录
  void _login() {
    var _phone = _honeController.text;
    var _pwd = _pwdeController.text;
    if (_phone.length != 11) {
      print("账号长度错误");
      return;
    }
    if (_pwd.length < 6 || _pwd.length > 16) {
      print("密码长度错误");
      return;
    }
    APIService.instance.getService(ApiConfig.login, queryParameters: {
      "phone": _phone,
      "password": _pwd,
      'project': AppConfig.project
    }).then((response) async {
      UserEntity _userEntity = UserEntity.fromJson(response.data);
      if (_userEntity.success) {
        _showToast("登录成功");
        SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        UserBean userBean = _userEntity.userBean;
        sharedPreferences
          ..setString("uuid", userBean.uuid)
          ..setInt("id", userBean.id)
          ..setString("phone", userBean.phone)
          ..setString("password", userBean.password)
          ..setString("head", userBean.head)
          ..setString("album", userBean.album)
          ..setString("nickName", userBean.nickName)
          ..setString("signature", userBean.signature)
          ..setInt("type", userBean.type)
          ..setString("projectKey", userBean.projectKey)
          ..setInt("talkCount", userBean.talkCount)
          ..setInt("followCount", userBean.followCount)
          ..setInt("fansCount", userBean.fansCount);
        Provider.of<MyProvider>(context).addUser(userBean);
        Navigator.pop(context);
      } else {
        _showToast(_userEntity.msg);
      }
    });
  }

  // 显示提示框
  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }
}
