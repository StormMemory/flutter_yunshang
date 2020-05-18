import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:futures/app/ColorConfig.dart';

class PersionalModify extends StatefulWidget {
  PersionalModify({Key key, this.type}) : super(key: key);

  final int type;

  @override
  _PersionalModifyState createState() => _PersionalModifyState();
}

class _PersionalModifyState extends State<PersionalModify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        leading: GestureDetector(
          child: Container(
            child: Icon(Icons.arrow_back_ios),
          ),
          onTap: () {
            Navigator.pop(context, "");
          },
        ),
        backgroundColor: ColorConfig.appBarColor,
        title: Text(
          widget.type == 1 ? "昵称" : "个性签名",
          style: TextStyle(fontSize: 20),
        ),
        actions: <Widget>[
          GestureDetector(
            child: Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              child: Text(
                "保存",
                style: TextStyle(fontSize: 18),
              ),
            ),
            onTap: () {
              String _content = _contetController.text;
              if (_content.isEmpty) {
                Fluttertoast.showToast(
                    msg: "昵称不能完全是空白符!",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 16);
              } else {
                Navigator.pop(context, _content);
              }
            },
          )
        ],
      ),
      body: _body(),
    );
  }

  TextEditingController _contetController;

  @override
  void initState() {
    super.initState();
    _contetController = TextEditingController();
  }

  Widget _body() => Container(
        color: Colors.white,
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.only(left: 20, right: 20, top: 32, bottom: 32),
        child: CupertinoTextField(
          controller: _contetController,
          maxLines: 1,
          maxLengthEnforced: true,
          enableInteractiveSelection: false,
          maxLength: widget.type == 1 ? 6 : 16,
          style: TextStyle(color: Colors.black, fontSize: 18),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.transparent),
          ),
          placeholder: "最多${widget.type == 1 ? "6" : "16"}个字",
        ),
      );
}
