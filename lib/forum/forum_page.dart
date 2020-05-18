import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:futures/app/ColorConfig.dart';
import 'package:futures/forum/forum_dynamic.dart';

class ForumPage extends StatefulWidget {
  ForumPage({Key key}) : super(key: key);

  @override
  _ForumPageState createState() => _ForumPageState();
}

class TabBarTitle {
  String title;
  int id;
  TabBarTitle(this.title, this.id);
}

class _ForumPageState extends State<ForumPage> with SingleTickerProviderStateMixin {
  TabController tabBarController;
  PageController mPageController = PageController(initialPage: 0);
  List<TabBarTitle> tabList;
  var currentPage = 0;
  var isPageCanChanged = true;

  @override
  void initState() {
    super.initState();
    initTabBarData();
    tabBarController = TabController(
      length: tabList.length,
      vsync: this,
    );
    tabBarController.addListener(() {
      //TabBar的监听
      if (tabBarController.indexIsChanging) {
        _pageChange(tabBarController.index, p: mPageController);
      }
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TabBar(
          isScrollable: true,
          indicatorColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          //是否可以滚动
          controller: tabBarController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white,
          labelStyle: TextStyle(fontSize: 18.0),
          tabs: tabList.map((item) {
            return Tab(
              text: item.title,
            );
          }).toList(),
        ),
        backgroundColor: ColorConfig.appBarColor,
      ),
      // floatingActionButton: FloatingActionButton(
      //   child: Icon(Icons.add),
      //   backgroundColor: ColorConfig.appBarColor,
      //   elevation: 2.0,
      //   highlightElevation: 2.0,
      //   onPressed: () {
      //     Navigator.of(context).push(MaterialPageRoute(builder: (_) {
      //       return Provider.of<PersonalProvider>(context).getUser() == null
      //           ? Login()
      //           : PostDiscussion();
      //     }));
      //   },
      // ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              itemCount: tabList.length,
              onPageChanged: (index) {
                if (isPageCanChanged) {
                  _pageChange(index);
                }
              },
              controller: mPageController,
              itemBuilder: (BuildContext context, int index) {
                return ForumDynamic(
                  index: tabList[index].id,
                );
              },
            ),
          )
        ],
      ),
    );
  }

  initTabBarData() {
    tabList = [
      TabBarTitle('关注', 1),
      // TabBarTitle('最新', 2),
      TabBarTitle('热门', 2),
    ];
  }

  _pageChange(int index, {PageController p, TabController t}) async {
    if (p != null) {
      isPageCanChanged = false;
      await mPageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
      isPageCanChanged = true;
    } else {
      tabBarController.animateTo(index);
    }
  }

  @override
  void dispose() {
    super.dispose();
    tabBarController.dispose();
  }
}
