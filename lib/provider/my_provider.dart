import 'package:flutter/cupertino.dart';
import 'package:futures/entity/UserBean.dart';

class MyProvider with ChangeNotifier {
  UserBean _userBean;

  int _index;

  MyProvider(this._userBean, this._index);

  UserBean getUser() => _userBean;

  int getIndex() => _index;

  _setUser(UserBean userBean) => _userBean = userBean;

  _setIndex(int index) => _index = index;

  void removeUser() {
    _userBean = null;
    notifyListeners();
  }

  // 添加用户
  void addUser(UserBean userBean) {
    _setUser(userBean);
    notifyListeners();
  }

  // 添加用户
  void addIndex(int  index) {
    _setIndex(index);
    notifyListeners();
  }

  // 更新用户
  void updateUser(UserBean userBean) {
    _setUser(userBean);
    notifyListeners();
  }

  // 更新用户
  void updateIndex(int index) {
    _setIndex(index);
    notifyListeners();
  }
}
