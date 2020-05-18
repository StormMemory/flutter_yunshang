import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/BaseEntity.dart';
import 'package:futures/entity/CodeEntity.dart';
import 'package:futures/api/APIService.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:futures/web/Web.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 注册
class Register extends StatefulWidget {
  Register({Key key, this.type}) : super(key: key);
  final int type; //1-注册 2-重置密码
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0,
        backgroundColor: Colors.white,
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

  TextEditingController _phoneController = TextEditingController();
  TextEditingController _pwdeController = TextEditingController();
  TextEditingController _codeController = TextEditingController();

  // 是否是忘记密码
  String _title() {
    switch (widget.type) {
      case 1:
        return "账号注册";
      case 3:
        return "修改密码";
      default:
        return "忘记密码";
    }
  }

  // 按钮上的文字
  String _submitName() {
    switch (widget.type) {
      case 1:
        return "注册";
      default:
        return "提交";
    }
  }

  // 主体界面
  Widget _body() => SingleChildScrollView(
        padding: EdgeInsets.only(left: 37, right: 37, top: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              _title(),
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
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                maxLines: 1, //最大行数
                maxLength: 11, //最大长度
                controller: _phoneController,
                decoration:
                    InputDecoration(hintText: "请输入你的账号", counterText: ""),
                keyboardType: TextInputType.phone,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 20,bottom: 5),
              child: Text(
                "验证码",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontStyle: FontStyle.normal),
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _codeController,
                    enableInteractiveSelection: false,
                    keyboardType: TextInputType.phone,
                    maxLength: 6,
                    maxLines: 1,
                    decoration: InputDecoration(
                      counterText: "",
                      hintText: '请输入验证码',
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: GestureDetector(
                    onTap: _sendCode,
                    child: Container(
                      height: MediaQuery.of(context).size.width/8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        color: ColorConfig.appBarColor,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _codeCountDownStr,
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ),
                )
              ],
            ),
            // Container(
            //   margin: EdgeInsets.only(top: 20),
            //   child: TextField(
            //     controller: _codeController,
            //     enableInteractiveSelection: false,
            //     keyboardType: TextInputType.phone,
            //     maxLength: 6,
            //     maxLines: 1,
            //     decoration: InputDecoration(
            //       suffixIcon: GestureDetector(
            //         onTap: _sendCode,
            //         child: Container(
            //           width: 100,
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.all(Radius.circular(10)),
            //             color: ColorConfig.appBarColor,
            //           ),
            //           alignment: Alignment.center,
            //           child: Text(
            //             _codeCountDownStr,
            //             style: TextStyle(color: Colors.white, fontSize: 12),
            //           ),
            //         ),
            //       ),
            //       counterText: "",
            //       hintText: '请输入验证码',
            //     ),
            //   ),
            // ),
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
              margin: EdgeInsets.only(top: 10),
              child: TextField(
                maxLines: 1,
                controller: _pwdeController,
                maxLength: 16,
                decoration:
                    InputDecoration(hintText: "请输入你的密码", counterText: ""),
                obscureText: true,
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
                onPressed: _submit,
                child: Text(
                  _submitName(),
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            _agreement()
          ],
        ),
      );
  // 是否显示用户协议
  Widget _agreement() {
    if (widget.type == 1) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return Web(
                url: ApiConfig.agreement,
                appBar: "用户协议",
              );
            }));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("注册即表示同意"),
              Text(
                "《用户协议》",
                style: TextStyle(color: ColorConfig.appBarColor),
              )
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  // 注册
  void _submit() {
    String phone = _phoneController.text;
    if (phone.length != 11) {
      _showToast("请输入正确的手机号！");
      return;
    }
    String code = _codeController.text;
    if (code.length != 6) {
      _showToast("验证码格式不正确！");
      return;
    }
    String pwd = _pwdeController.text;
    if (pwd.length < 6 || pwd.length > 16) {
      _showToast("请输入6-16位的密！");
      return;
    }
    _registerOrRestPassword(phone, pwd, code);
  }

  // 重置和注册
  void _registerOrRestPassword(String phone, String pwd, String code) {
    String url;
    switch (widget.type) {
      case 1:
        url = ApiConfig.register;
        break;
      default:
        url = ApiConfig.resetPassword;
        break;
    }
    APIService.instance.postService(url, parameters: {
      'phone': phone,
      'password': pwd,
      "newPassword": pwd,
      'confirmPassword': pwd,
      'code': code,
      'type': widget.type == 1 ? 1 : 2, //1-普通用户 2-系统用户
      'project': AppConfig.project
    }).then((response) async {
      BaseEntity baseEntity = BaseEntity.fromJson(response.data);
      if (baseEntity.success) {
        switch (widget.type) {
          case 1:
            _showToast("注册成功");
            break;
          case 2:
            _showToast("已重置密码");
            break;
          case 3:
            _showToast("已重置密码");
            Provider.of<MyProvider>(context).removeUser();
            SharedPreferences prefs = await SharedPreferences.getInstance();
            prefs.clear();
            // Navigator.of(context).push(MaterialPageRoute(builder: (_) {
            //   return Login();
            // }));
            break;
          default:
        }
        Navigator.of(context, rootNavigator: true).pop();
      } else {
        _showToast(baseEntity.msg);
      }
    }).catchError((onError) {
      _showToast(AppConfig.onErrorMsg);
    });
  }

  // 发送验证码
  void _sendCode() {
    if (isCodeing) {
      return;
    }
    String phone = _phoneController.text;
    if (phone.length != 11) {
      _showToast("请输入正确的手机号！");
      return;
    }
    APIService.instance.postService(ApiConfig.sendCode, parameters: {
      'phone': phone,
      'type': widget.type == 1 ? 1 : 2, //1-注册 2-重置密码
      'project': AppConfig.project
    }).then((response) async {
      CodeEntity codeEntity = CodeEntity.fromJson(response.data);
      if (codeEntity.success) {
        isCodeing = true;
        _showToast("验证码发送成功");
        if (_timer != null) {
          return;
        }
        setState(() {
          _codeCountDownStr = "${_countDownNum}s重新获取";
        });
        _timer = Timer.periodic(Duration(seconds: 1), (timer) {
          setState(() {
            if (_countDownNum > 0) {
              _codeCountDownStr = "${_countDownNum--}s重新获取";
            } else {
              _codeCountDownStr = '获取验证码';
              _countDownNum = 59;
              _timer.cancel();
              _timer = null;
              isCodeing = false;
            }
          });
        });
      } else {
        _showToast(codeEntity.msg);
      }
    }).catchError((onError) {
      _showToast(AppConfig.onErrorMsg);
    });
  }

  bool isCodeing = false;
  Timer _timer;
  int _countDownNum = 60;

  // 显示提示
  void _showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }

  String _codeCountDownStr = "获取验证码";
}
