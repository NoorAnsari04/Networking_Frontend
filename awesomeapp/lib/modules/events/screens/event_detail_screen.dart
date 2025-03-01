import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/events/components/event_poster.dart';
import 'package:my_test_app_flavors/modules/events/screens/ticket_screen.dart';
import 'package:my_test_app_flavors/modules/events/speakers/services/speaker_provider.dart';
import 'package:my_test_app_flavors/modules/events/ticket/services/ticket_provider.dart';
import 'package:provider/provider.dart';
import '../components/grid_items.dart';
import '../services/event_model.dart';
import '../speakers/screens/speakers_screen.dart';
import '../swipe and connect/screens/swipe_and_connect.dart';

class EventDetailScreen extends StatefulWidget {
  static const id = 'eventDetails';
  final EventModel event;
  final AppUser appUser;

  const EventDetailScreen(
      {Key? key, required this.event, required this.appUser})
      : super(key: key);

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
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
                    widget.event.title,
                    style: TextStyle(fontSize: 28.sp),
                  ),
                ),
              ),
            ),
            EventImageWidget(event: widget.event),
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
                      onTap: () async {
                        final ticketProvider =
                            Provider.of<TicketProvider>(context, listen: false);
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                                  child: CircularProgressIndicator(),
                                ));
                        try {
                          await ticketProvider
                              .fetchTicketDetails(widget.event.eventId);
                          Navigator.pop(context);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TicketScreen(
                                      appUser: widget.appUser,
                                      eventModel: widget.event,
                                      ticketDetails:
                                          ticketProvider.ticketDetails)));
                        } catch (e) {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Failed to load ticket")));
                        }
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
                      onTap: () async {
                        final speakerProvider = Provider.of<SpeakerProvider>(
                            context,
                            listen: false);
                        try {
                          await speakerProvider
                              .fetchSpeakers(widget.event.eventId);
                          context.pushNamed(SpeakersScreen.id);
                        } catch (e) {
                          print("Error fetching speakers: $e");
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Failed to load speakers.')));
                        }
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
