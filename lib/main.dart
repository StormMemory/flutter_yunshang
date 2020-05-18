import 'package:flutter/material.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:futures/switch/splash_page.dart';
import 'package:futures/web/NewsContent.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:provider/provider.dart';

import 'entity/ConfigBean.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // _jpushInstance();
  runApp(MyApp());
}

// 注册极光推送
// _jpushInstance() {
//   JPush jPush = JPush(); 
//   jPush.applyPushAuthority(
//       NotificationSettingsIOS(sound: true, alert: true, badge: true));
//   jPush.setup(
//     appKey: "491541e64591a8389317cfe3",
//     channel: "App Store",
//     production: true,
//     debug: true, // 设置是否打印 debug 日志
//   );
// }

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyProvider>(
      builder: (context) => MyProvider(null, 0),
      child: MaterialApp(
        debugShowCheckedModeBanner: AppConfig.showDebugBanner,
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: SplashPage(),
      ),
    );
  }
}

class NewsPage extends StatelessWidget {
  final ConfigBean bean;

  NewsPage({Key key, this.bean}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewsContent(
        config: bean,
      ),
    );
  }
}
