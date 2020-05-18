import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ColorConfig.dart';

class FeedBack extends StatefulWidget {
  @override
  _FeedBackState createState() => _FeedBackState();
}

class _FeedBackState extends State<FeedBack> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorConfig.appBarColor,
        title: Text(
          "意见反馈",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: _body(),
    );
  }

  // 主页面
  Widget _body() => Container(
        child: Column(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(10),
              child: Theme(
                data: new ThemeData(
                  primaryColor: ColorConfig.appBarColor,
                ),
                child: TextField(
                  controller: _textEditingController,
                  maxLines: 6,
                  minLines: 6,
                  decoration: InputDecoration(
                      hintStyle: TextStyle(fontSize: 16, color: Colors.black54),
                      hintText: "请填写你的意见或建议！",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                              color: ColorConfig.appBarColor, width: 1))),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if (_textEditingController.text.trim().length < 1) {
                  Fluttertoast.showToast(
                      msg: "请先输入要提交的问题！",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      fontSize: 14);
                  return;
                }
                _textEditingController.text = "";
                setState(() {});
                Fluttertoast.showToast(
                    msg: "关于你反馈的问题，我们已经接受，请等待。",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 14);
              },
              child: Container(
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: ColorConfig.appBarColor,
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(top: 40, left: 20, right: 20),
                child: Text(
                  "提交反馈",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      );
  TextEditingController _textEditingController;
  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }
}
