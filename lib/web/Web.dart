import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:futures/app/ColorConfig.dart';

class Web extends StatefulWidget {
  Web({Key key, this.url, this.appBar}) : super(key: key);

  final String url;
  final String appBar;

  @override
  _WebState createState() => _WebState();
}

class _WebState extends State<Web> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  Widget _appBar() {
    if (widget == null || widget.appBar.isNotEmpty) {
      return AppBar(
        backgroundColor: ColorConfig.appBarColor,
        title: Text(
          widget.appBar,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      );
    } else {
      return null;
    }
  }

  // 主体框架布局
  Widget _body() => WebviewScaffold(
        url: widget.url,
      );
}
