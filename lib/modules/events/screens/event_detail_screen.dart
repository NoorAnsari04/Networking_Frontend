import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/events/components/event_poster.dart';
import 'package:my_test_app_flavors/modules/events/screens/ticket_screen.dart';
import '../components/grid_items.dart';
import '../services/event_model.dart';
import '../speakers/screens/speakers_screen.dart';
import '../swipe and connect/screens/swipe_and_connect.dart';

class EventDetailScreen extends StatelessWidget {
  static const id = 'eventDetails';
  final EventModel event;
  final AppUser appUser;

  EventDetailScreen({required this.event, required this.appUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 40.h, left: 16.w, right: 16.w),
              child: Align(
                alignment: Alignment.centerLeft,
                child: SafeArea(
                  child: Text(
                    event.title,
                    style: TextStyle(fontSize: 28.sp),
                  ),
                ),
              ),
            ),
            EventImageWidget(event: event),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                width: double.infinity,
                height: 600.h,
                child: Stack(
                  children: [
                    GridItems(
                      title: 'Your Ticket',
                      backgroundImagePath: 'assets/tickets.png',
                      width: 201.w,
                      height: 179.92.h,
                      top: 0.h,
                      left: 0.w,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TicketScreen(
                              appUser: appUser,
                              eventModel: event,
                            ),
                          ),
                        );
                      },
                    ),
                    GridItems(
                      title: '',
                      backgroundImagePath: 'assets/rt.PNG',
                      width: 133.w,
                      height: 130.h,
                      top: 0.h,
                      left: 207.w,
                      onTap: () {},
                    ),
                    GridItems(
                      title: '',
                      backgroundImagePath: 'assets/speakers.png',
                      width: 201.w,
                      height: 93.h,
                      top: 185.h,
                      left: 0.w,
                      onTap: () {
                        context.pushNamed(SpeakersScreen.id);
                      },
                    ),
                    GridItems(
                      title: 'Agenda',
                      backgroundImagePath: 'assets/agenda.png',
                      width: 132.w,
                      height: 142.h,
                      top: 135.h,
                      left: 207.w,
                      onTap: () {},
                    ),
                    GridItems(
                      title: '',
                      backgroundImagePath: 'assets/reactree.png',
                      width: 201.w,
                      height: 173.h,
                      top: 285.h,
                      left: 0.w,
                      onTap: () {},
                    ),
                    GridItems(
                      title: 'Network',
                      backgroundImagePath: 'assets/network.png',
                      width: 132.w,
                      height: 179.56.h,
                      top: 278.h,
                      left: 207.w,
                      onTap: () {
                        context.pushNamed(SwipeAndConnectScreen.id);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
