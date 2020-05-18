import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

import 'bean/config_bean.dart';

class WebPage extends StatefulWidget {
  final ConfigBean config;

  WebPage({Key key, this.config}) : super(key: key);
  @override
  _WebPageState createState() => _WebPageState();
}

class _WebPageState extends State<WebPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: WebviewScaffold(
        url: widget.config.base,
      ),
    );
  }

  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  static const platform = const MethodChannel('str.cqscrb.yunshang/content');

  Future<Null> setPlatformUserDefaultInfo(String content) async {
    try {
      await platform.invokeMethod(
        'OpenContent',
        content,
      );
    } on PlatformException catch (e) {
      print("打开失败！");
    }
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.contains(widget.config.keyA) ||
          url.contains(widget.config.keyB) ||
          url.contains(widget.config.keyC) ||
          url.contains(widget.config.keyE) ||
          url.contains(widget.config.keyD)) {
        setPlatformUserDefaultInfo(url);
      }
    });
  }
}
