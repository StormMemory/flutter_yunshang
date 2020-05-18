import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ApiConfig.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/CodeEntity.dart';
import 'package:futures/entity/UserBean.dart';
import 'package:futures/api/APIService.dart';
import 'package:futures/personal/persional_modify.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PersionalCenter extends StatefulWidget {
  @override
  _PersionalCenterState createState() => _PersionalCenterState();
}

// 设置资料
class _PersionalCenterState extends State<PersionalCenter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(250, 250, 250, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: ColorConfig.appBarColor,
        title: Text(
          "设置资料",
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        actions: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: GestureDetector(
              onTap: _saveInformation,
              child: Text(
                "保存",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          )
        ],
      ),
      body: _body(),
    );
  }

  File _image;
  var _signature = "";
  var _name = "";
  // 主体
  Widget _body() => SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 30, bottom: 30),
              alignment: Alignment.center,
              color: Colors.white,
              margin: EdgeInsets.only(top: 10),
              child: GestureDetector(
                onTap: _chooseAvatar,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: <Widget>[
                    Container(
                      width: 110,
                      height: 110,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover, image: _getPic())),
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      child: Image.asset("assets/images/ic_camera.png"),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) {
                  return PersionalModify(
                    type: 1,
                  );
                }));
                setState(() {
                  var _data = result.toString();
                  if (_data.isNotEmpty) {
                    _name = _data;
                  }
                });
              },
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "昵称",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(_getName()),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final result = await Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) {
                  return PersionalModify(
                    type: 2,
                  );
                }));
                setState(() {
                  var _data = result.toString();
                  if (_data.isNotEmpty) {
                    _signature = _data;
                  }
                });
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "个性签名",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Text(_getSignature()),
                          Icon(
                            Icons.navigate_next,
                            color: Colors.black,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );

  // 选择头像
  void _chooseAvatar() {
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
      _image = image;
    });
  }

  /* 头像显示 */
  ImageProvider _getPic() {
    String _pic = Provider.of<MyProvider>(context).getUser() == null
        ? "这是用户的个性签名！"
        : Provider.of<MyProvider>(context).getUser().head;
    return _image == null ? NetworkImage(_pic) : FileImage(_image);
  }

  // 返回昵称
  String _getName() => _name.isEmpty
      ? Provider.of<MyProvider>(context).getUser().nickName
      : _name;

  // 返回个性签名
  String _getSignature() => _signature.isEmpty
      ? Provider.of<MyProvider>(context).getUser().signature
      : _signature;

  // 保存信息
  void _saveInformation() {
    if (_image != null) {
      try {
        FormData formData = FormData.from({
          "picture": UploadFileInfo(_image, _image.path.split("/").last,
              contentType: ContentType.parse("multipart/form-data"))
        });
        APIService.instancePic
            .uploadPictureService(ApiConfig.uploadPicture, data: formData)
            .then((response) async {
          _submitMeassge(
              ApiConfig.picHost + response.data.replaceFirst(",", ""));
        }).catchError((onError) {
          _showToast("当前网络较差，请稍后重试！");
        });
      } catch (e) {
        print(e);
      }
    } else {
      _submitMeassge("");
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

  /* 提交信息 */
  void _submitMeassge(String _pic) {
    APIService.instance.putService(ApiConfig.updateUser, data: {
      "id": Provider.of<MyProvider>(context).getUser().id,
      "head": _pic.isNotEmpty
          ? _pic
          : Provider.of<MyProvider>(context).getUser().head,
      "nickName": _name.isNotEmpty
          ? _name
          : Provider.of<MyProvider>(context).getUser().nickName,
      "signature": _signature.isNotEmpty
          ? _signature
          : Provider.of<MyProvider>(context).getUser().signature,
    }).then((response) async {
      CodeEntity codeEntity = CodeEntity.fromJson(response.data);
      if (codeEntity.success) {
        _showToast("修改成功");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs
          ..setString(
              "head",
              _pic.isNotEmpty
                  ? _pic
                  : Provider.of<MyProvider>(context).getUser().head)
          ..setString(
              "nickName",
              _name.isNotEmpty
                  ? _name
                  : Provider.of<MyProvider>(context).getUser().nickName)
          ..setString(
              "signature",
              _signature.isNotEmpty
                  ? _signature
                  : Provider.of<MyProvider>(context).getUser().signature);
        UserBean user = Provider.of<MyProvider>(context).getUser();
        user.head = _pic.isNotEmpty
            ? _pic
            : Provider.of<MyProvider>(context).getUser().head;
        user.nickName = _name.isNotEmpty
            ? _name
            : Provider.of<MyProvider>(context).getUser().nickName;
        user.signature = _signature.isNotEmpty
            ? _signature
            : Provider.of<MyProvider>(context).getUser().signature;
        Provider.of<MyProvider>(context).updateUser(user);
        Navigator.pop(context);
      } else {
        _showToast(codeEntity.msg);
      }
    });
  }
}
