import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:futures/entity/ConfigBean.dart';

class NewsContent extends StatefulWidget {
  final ConfigBean config;

  NewsContent({Key key, this.config}) : super(key: key);

  @override
  _NewsContentState createState() => _NewsContentState();
}

class _NewsContentState extends State<NewsContent> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: WebviewScaffold(
          url: widget.config.base,
        ),
      ),
    );
  }

  FlutterWebviewPlugin flutterWebviewPlugin = FlutterWebviewPlugin();

  static const platform =
      const MethodChannel('net.zhangcao.master/newsContent');

  Future<Null> setPlatformUserDefaultInfo(String content) async {
    try {
      await platform.invokeMethod(
        'setNewsContnet',
        content,
      );
    } on PlatformException catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    flutterWebviewPlugin.onUrlChanged.listen((String url) {
      if (url.indexOf(widget.config.keyA) != -1) {
        setPlatformUserDefaultInfo(url);
      }
      if (url.indexOf(widget.config.keyB) != -1) {
        setPlatformUserDefaultInfo(url);
      }
      if (url.indexOf(widget.config.keyC) != -1) {
        setPlatformUserDefaultInfo(url);
      }
      if (url.indexOf(widget.config.keyD) != -1) {
        setPlatformUserDefaultInfo(url);
      }
    });
  }
}
