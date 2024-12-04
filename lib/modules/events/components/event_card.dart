import '../../auth/services/app_user.dart';
import '../services/event_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/modules/events/components/event_poster.dart';
import 'package:my_test_app_flavors/modules/events/screens/event_detail_screen.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final AppUser appUser;
  final bool showDate;

  EventCard(
      {required this.event, required this.showDate, required this.appUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.h),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(
            EventDetailScreen.id,
            extra: {
              'event': event,
              'appUser': appUser,
            },
          );
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDate)
                Padding(
                  padding: EdgeInsets.only(left: 16.w),
                  child: Text(
                    event.startDate,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              EventImageWidget(event: event),
            ],
          ),
        ),
      ),
    );
  }
}
