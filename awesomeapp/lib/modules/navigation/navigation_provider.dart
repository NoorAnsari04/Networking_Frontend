import 'package:flutter/cupertino.dart';
import 'package:my_test_app_flavors/modules/auth/screens/login_screen.dart';

class NavigationProvider extends ChangeNotifier {
  int currentTabIndex = 0;
  late PageController controller;
  bool isLoading = false;
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();



  void changeTab(int newIndex) {
    if (this.currentTabIndex != newIndex) {
      this.currentTabIndex = newIndex;
      this.controller.jumpToPage(newIndex);
      notifyListeners();
    }
  }

  void resetTab() {
    this.currentTabIndex = 0;
  }

  updateLoading(bool val) {
    this.isLoading = val;
    notifyListeners();
  }

  void navigateToLogin(BuildContext context){
    Navigator.pushAndRemoveUntil(context, CupertinoPageRoute(builder: (context) => LoginScreen()), (route) => false);
  }
}
