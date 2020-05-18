import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futures/main/main_page.dart';
import 'package:package_info/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bean/config_bean.dart';
import 'bean/leanclound_bean.dart';
import 'bean/mock_controller_bean.dart';
import 'uitls/leancloud_util.dart';
import 'uitls/mock_util.dart';
import 'web_page.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/images/1242_2688.jpg',
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _getOpen();
  }

  // 获取是否第一次打开
  void _getOpen() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String open = sharedPreferences.getString("open");
    if (open == "1") {
      _requestMock();
    } else {
      sharedPreferences.setString("open", "1");
      //打开原生app
      _openNative();
    }
  }

  ///请求mock
  void _requestMock() {
    MockUtil.instance.getMock().then((response) async {
      if (response.data.toString().isEmpty) {
        ///请求leancloud
        _requestLeancloud();
      } else {
        MockControllerBean mockControllerBean =
            MockControllerBean.fromJson(response.data);
        //判断是否用leancloud请求开关1为用Leancloud请求开关
        if (mockControllerBean.isLeanCloud == "1") {
          //请求leancloud
          _requestLeancloud();
        } else {
          _packageInfo(mockControllerBean.config, mockControllerBean.version);
        }
      }
    }).catchError((onError) {
      ///请求LeanCloud
      _requestLeancloud();
    });
  }

  //请求leancloud
  void _requestLeancloud() {
    LeancloudUtil.instance.getLC().then((response) async {
      LeancloudBean leancloudBean = LeancloudBean.fromJson(response.data);
      _packageInfo(leancloudBean.config, leancloudBean.version);
    }).catchError((onError) {
      //打开原生
      _openNative();
    });
  }

  // 判断版本号和开关
  void _packageInfo(ConfigBean configBean, String version) {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) async {
      //判断版本号
      if (version == packageInfo.version) {
        //判断是否正在审核1为审核通过
        if (configBean.isAppStore == "1") {
          //跳转网页
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => WebPage(config: configBean)),
              (Route<dynamic> rout) => false);
        } else {
          //打开原生
          _openNative();
        }
      } else {
        //打开原生
        _openNative();
      }
    }).catchError((onError) async {
      //打开原生
      _openNative();
    });
  }

  /// 打开原生
  void _openNative() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainPage()),
        (Route<dynamic> rout) => false);
  }
}
