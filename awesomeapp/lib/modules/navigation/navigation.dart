import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/core/constants/icon_constants.dart';
import 'package:provider/provider.dart';
import '../screens/connection_requests.dart';
import '../screens/connections.dart';
import 'navigation_provider.dart';
import 'package:my_test_app_flavors/modules/events/attandees/screens/profile_screen.dart';
import 'package:my_test_app_flavors/modules/events/screens/home_screen.dart';

class NavigationScreen extends StatefulWidget {
  static const id = '/navigation';
  final StatefulNavigationShell navigationShell;

  NavigationScreen({required this.navigationShell});

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  late NavigationProvider _navigationProvider;

  List<Widget> tabs = [];

  Future<bool> _onWillPop() {
    if (this._navigationProvider.currentTabIndex > 0) {
      this._navigationProvider.changeTab(0);
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  @override
  void initState() {
    super.initState();

    this._navigationProvider =
        Provider.of<NavigationProvider>(context, listen: false);

    this._navigationProvider.controller = PageController(initialPage: 0);

    tabs.add(HomeScreen(
      changeBottomNavBarTab: this._navigationProvider.changeTab,
    ));

    tabs.add(ConnectionRequestsScreen());
    tabs.add(ConnectionsScreen()); // Add the ConnectionsScreen
    tabs.add(ProfileScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WillPopScope(
          onWillPop: _onWillPop,
          child: Scaffold(
            body: Consumer<NavigationProvider>(builder: (context, navProv, _) {
              return PageView(
                children: tabs,
                physics: NeverScrollableScrollPhysics(),
                controller: navProv.controller,
              );
            }),
            bottomNavigationBar:
                Consumer<NavigationProvider>(builder: (context, navProv, _) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                currentIndex: navProv.currentTabIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                backgroundColor: Colors.white,
                elevation: 0,
                onTap: this._navigationProvider.changeTab,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      IconConstants.requestIcon,
                      height: 20.h,
                      width: 20.w,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: SvgPicture.asset(
                      IconConstants.connectionIcon,
                      height: 18.h,
                      width: 20.w,
                    ),
                    label: "",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: "",
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }
}
