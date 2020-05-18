import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/BaseEntity.dart';
import 'package:futures/api/APIService.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

// 发布动态
class ForumRelease extends StatefulWidget {
  @override
  _ForumReleaseState createState() => _ForumReleaseState();
}

class _ForumReleaseState extends State<ForumRelease> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "发布动态",
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: ColorConfig.appBarColor,
        actions: <Widget>[
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: GestureDetector(
                onTap: _saveTalk,
                child: Text(
                  "发布",
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          )
        ],
      ),
      body: _body(),
    );
  }

  TextEditingController _editingController;

  Widget _body() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 20),
              child: TextField(
                maxLines: 10,
                textAlign: TextAlign.start,
                minLines: 10,
                style: TextStyle(fontSize: 14),
                controller: _editingController,
                decoration: InputDecoration(
                  hintText: "请输入想要发表且遵守相关法律法规的内容！",
                ), //border: InputBorder.none
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10, top: 10),
              alignment: Alignment.topLeft,
              child: Text(
                "选择配图:",
                style: TextStyle(fontSize: 12, color: ColorConfig.appBarColor),
              ),
            ),
            Container(
              // color: Colors.red,
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: _choosePic,
                child: Container(
                  width: 120,
                  height: 160,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorConfig.appBarColor, width: 1.0),
                      borderRadius: BorderRadius.circular(1.0)),
                  margin: EdgeInsets.only(left: 10, top: 10),
                  child: _getPic(),
                ),
              ),
            )
          ],
        ),
      );

  // 保存信息
  _saveTalk() {
    if (_editingController.text.trim().length < 1) {
      showToast("请输入发布内容！");
      return;
    }
    if (_file != null) {
      try {
        FormData formData = FormData.from({
          "picture": UploadFileInfo(_file, _file.path.split("/").last,
              contentType: ContentType.parse("multipart/form-data"))
        });
        APIService.instancePic
            .uploadPictureService(ApiConfig.uploadPicture, data: formData)
            .then((response) async {
          publishTalk(ApiConfig.picHost + response.data.replaceFirst(",", ""));
        }).catchError((onError) {
          showToast(AppConfig.onErrorMsg);
        });
      } catch (e) {
        showToast(AppConfig.onErrorMsg);
      }
    } else {
      publishTalk("");
    }
  }

  // 发布说说
  publishTalk(String _picUrl) {
    APIService.instance
        .postService(ApiConfig.publishTalk,
            parameters: _picUrl == ""
                ? {
                    "userId": Provider.of<MyProvider>(context)
                        .getUser()
                        .id
                        .toString(),
                    "content": _editingController.text,
                  }
                : {
                    "userId": Provider.of<MyProvider>(context)
                        .getUser()
                        .id
                        .toString(),
                    "content": _editingController.text,
                    "picture": _picUrl,
                    "displayBig": false
                  })
        .then((response) async {
      BaseEntity codeEntity = BaseEntity.fromJson(response.data);
      if (codeEntity.success) {
        showToast("发布成功");
        Navigator.pop(context);
      } else {
        showToast(codeEntity.msg);
      }
    }).catchError((onError) async {
      showToast(AppConfig.onErrorMsg);
    });
  }

  File _file;
  // 根据状态返回控件
  Widget _getPic() {
    if (_file == null) {
      return Icon(
        Icons.add,
        size: 70.0,
        color: Colors.black38,
      );
    } else {
      return Image(
        image: FileImage(_file),
        fit: BoxFit.cover,
      );
    }
  }

  // 选择头像
  void _choosePic() {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: Text(
              "请选择",
              style: TextStyle(
                  fontSize: 13, color: Color.fromRGBO(153, 153, 153, 1)),
            ),
            content: ListBody(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 21),
                  child: Divider(
                    height: 1,
                    color: Color.fromRGBO(205, 206, 210, 1),
                  ),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "拍照",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    getImage(ImageSource.camera);
                  },
                ),
                Divider(
                  height: 1,
                  color: Color.fromRGBO(205, 206, 210, 1),
                ),
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: Text(
                      "从相册选取",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                  onTap: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    getImage(ImageSource.gallery);
                  },
                ),
                Divider(
                  height: 1,
                  color: Color.fromRGBO(205, 206, 210, 1),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                child: Text("取消", style: TextStyle(color: Colors.redAccent)),
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                },
              ),
            ],
          );
        });
  }

  // 接收返回的图片
  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);
    setState(() {
      _file = image;
    });
  }

  // 显示提示框
  showToast(String msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        fontSize: 14);
  }

  @override
  void initState() {
    super.initState();
    _editingController = TextEditingController();
  }
}
