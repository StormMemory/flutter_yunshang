import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/entity/UserBean.dart';
import 'package:futures/app/AppConfig.dart';
import 'package:futures/forum/forum_dynamic.dart';
import 'package:futures/forum/forum_page.dart';
import 'package:futures/main/home_page.dart';
import 'package:futures/personal/persional_page.dart';
import 'package:futures/provider/my_provider.dart';
import 'package:futures/quotes/information_page.dart';
import 'package:futures/station/Login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// 主页
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConfig.appBarColor,
      // floatingActionButton: _floatingActionButtonBuild(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: _main(),
    );
  }

  Widget _floatingActionButtonBuild() => Container(
        padding: EdgeInsets.all(5),
        // margin: EdgeInsets.only(top: 20),
        height: 60,
        width: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60), color: Colors.white),
        child: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.black,
            size: 30,
          ),
          elevation: 0,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (_) {
              return Provider.of<MyProvider>(context).getUser() == null
                  ? Login()
                  : ForumDynamic();
            }));
          },
        ),
      );

  Widget _main() => Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: IndexedStack(
              index: Provider.of<MyProvider>(context).getIndex(),
              children: <Widget>[
                HomePage(),
                InformationPage(),
                ForumPage(),
                // NotificationPage(),
                PersionalPage()
              ],
            ),
          ),
          _bottomBar()
        ],
      );

  Widget _bottomBar() => Container(
        padding: EdgeInsets.fromLTRB(0, AppConfig.bottomBarPaddingSize, 0,
            AppConfig.bottomBarPaddingSize),
        decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: ColorConfig.divColor),
            ),
            color: ColorConfig.themeColor),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _bottomBarItem(0),
                _bottomBarItem(1),
                _bottomBarItem(2),
                _bottomBarItem(3),
                // _bottomBarItem(4),
              ],
            ),
            SizedBox()
          ],
        ),
      );
  // 构建BottomBar的item
  Widget _bottomBarItem(int index) => GestureDetector(
        onTap: () {
          if (Provider.of<MyProvider>(context).getIndex() != index) {
            setState(() {
              Provider.of<MyProvider>(context).updateIndex(index);
            });
          }
        },
        behavior: HitTestBehavior.translucent,
        child: Column(
          children: <Widget>[
            Image.asset(
              Provider.of<MyProvider>(context).getIndex() == index
                  ? _icons[index]["selected"]
                  : _icons[index]["normal"],
              color: Provider.of<MyProvider>(context).getIndex() == index
                  ? _iconColor["selected"]
                  : _iconColor["normal"],
              height: 20.0,
            ),
            Text(
              _titles[index],
              style: TextStyle(
                color:
                    Provider.of<MyProvider>(context).getIndex() == index
                        ? _fontColor["selected"]
                        : _fontColor["normal"],
                fontSize: 13.0,
              ),
            ),
          ],
        ),
      );

  List<String> _titles = ["主页", "指数", "论坛", "我的"];
  List<Map<String, String>> _icons = [
    {
      "selected": "assets/images/bar_home_selecet.png",
      "normal": "assets/images/bar_home.png",
    },
    {
      "selected": "assets/images/bar_index_selecet.png",
      "normal": "assets/images/bar_index.png",
    },
    {
      "selected": "assets/images/bar_forum_selecet.png",
      "normal": "assets/images/bar_forum.png",
    },
    {
      "selected": "assets/images/bar_mine_selecet.png",
      "normal": "assets/images/bar_mine.png",
    },
    // {
    //   "selected": "assets/images/bar_notice_selecet.png",
    //   "normal": "assets/images/bar_notice.png",
    // },
  ];

  //bar的图片颜色
  Map<String, Color> _iconColor = {
    "selected": ColorConfig.appBarColor,
    "normal": ColorConfig.bottomBarColor,
  };

  //bar的文字颜色
  Map<String, Color> _fontColor = {
    "select": ColorConfig.appBarColor,
    "normal": ColorConfig.bottomBarColor,
  };

  _savedUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt("id") != null) {
      // 有数据
      UserBean user = UserBean()
        ..uuid = prefs.getString("uuid")
        ..id = prefs.getInt("id")
        ..phone = prefs.getString("phone")
        ..password = prefs.getString("password")
        ..head = prefs.getString("head")
        ..album = prefs.getString("album")
        ..nickName = prefs.getString("nickName")
        ..signature = prefs.getString("signature")
        ..type = prefs.getInt("type")
        ..projectKey = prefs.getString("projectKey")
        ..talkCount = prefs.getInt("talkCount")
        ..followCount = prefs.getInt("followCount")
        ..fansCount = prefs.getInt("fansCount");
      Provider.of<MyProvider>(context).addUser(user);
    }
  }

  @override
  void initState() {
    super.initState();
    _savedUser();
  }
}
