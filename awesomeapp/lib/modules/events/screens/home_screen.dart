import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';
import 'package:my_test_app_flavors/modules/events/services/event_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../core/constants/font_constants.dart';
import '../../auth/services/auth_provider.dart';
import '../components/event_card.dart';
import '../services/event_model.dart';

class HomeScreen extends StatefulWidget {
  static const id = 'homeScreen';

  final void Function(int index)? changeBottomNavBarTab;

  HomeScreen({this.changeBottomNavBarTab});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EventProvider>(context, listen: false).fetchEvents();
    });
  }

  Widget _buildEventList(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (context, eventProvider, child) {
        if (eventProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (eventProvider.events.isEmpty) {
          return Center(child: Text('No events found'));
        } else {
          List<EventModel> events = eventProvider.events;

          return Consumer<AuthenticationProvider>(
            builder: (context, authProv, _) {
              final appUser = authProv.appUser;
              if (appUser == null) {
                return Center(child: Text('User not found'));
              }

              return ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 10.h),
                    child: SafeArea(
                      child: Text(
                        '${EventModel.getGreeting()} ${appUser.name}',
                        style: ktopTextStyle.copyWith(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // CarouselSlider(
                  //   options: CarouselOptions(
                  //     onPageChanged: (index, reason) {
                  //       setState(() {
                  //         currentIndex = index;
                  //       });
                  //     },
                  //     aspectRatio: 1.8,
                  //     viewportFraction: 1,
                  //     enlargeCenterPage: true,
                  //   ),
                  //   items: events.map((event) {
                  //     return EventCard(
                  //         event: event, showDate: false, appUser: appUser);
                  //   }).toList(),
                  // ),
                  SizedBox(height: Get.height * 0.02),
                  Center(
                    child: AnimatedSmoothIndicator(
                      activeIndex: currentIndex,
                      count: events.length,
                      effect: ExpandingDotsEffect(
                        activeDotColor: ColorConstants.sliderColor,
                        dotColor: ColorConstants.sliderColor,
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Padding(
                    padding: EdgeInsets.only(left: 16.w, top: 4.h),
                    child: Text(
                      'Upcoming Events',
                      style: ktopTextStyle.copyWith(
                        color: ColorConstants.primaryColor,
                      ),
                    ),
                  ),
                  ...events
                      .map((event) => EventCard(
                          event: event, showDate: true, appUser: appUser))
                      .toList(),
                ],
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _buildEventList(context),
    );
  }
}
