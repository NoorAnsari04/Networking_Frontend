import 'package:flutter/cupertino.dart';

class NavigationProvider extends ChangeNotifier {
  int currentTabIndex = 0;
  late PageController controller;
  bool isLoading = false;

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
}
