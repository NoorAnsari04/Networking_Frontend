import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';
import 'package:my_test_app_flavors/modules/events/screens/event_detail_screen.dart';
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
  bool isLoading = true;
  List<EventModel> Events = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final authProvider =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final token = await authProvider.authToken();
      print("Token: $token");
      print("AppUser: ${authProvider.appUser}");
      if (token != null && token.isNotEmpty && authProvider.appUser != null) {
        Provider.of<EventProvider>(context, listen: false).fetchEvents();
      } else {
        print('User not authenticated, skipping fetchEvents');
      }
    });
  }

  Widget _buildEventList(BuildContext context) {
    return Consumer<EventProvider>(
      builder: (_, eventProvider, child) {
        if (eventProvider.isLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (eventProvider.events.isEmpty) {
          return Center(child: Text('No events found'));
        } else {
          List<EventModel> events = eventProvider.events;
          log(events.length.toString());

          return Consumer<AuthenticationProvider>(
            builder: (_, authProv, __) {
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
                        '${EventModel.getGreeting()} ${appUser.fullName}',
                        style: ktopTextStyle.copyWith(
                          fontSize: 16.0.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // ElevatedButton(
                  //   onPressed: () {
                  //     print('Navigating to EventDetailScreen manually...');
                  //     final dummyEvent = EventModel(
                  //       eventId: '676ebe7d13772a3338a9d888',
                  //       title: 'Chai Hour',
                  //       time: '3:00 pm',
                  //       venue: 'Pearl Continental',
                  //       endDate: '30-Dec-24',
                  //       startDate: '28-Dec-24',
                  //       posterUrl:
                  //       'https://res.cloudinary.com/startup-grind/image/upload/c_scale,w_2560/c_crop,h_640,w_2560,y_0.04_mul_h_sub_0.04_mul_640/c_crop,h_640,w_2560/c_fill,dpr_2.0,f_auto,g_center,q_auto:good/v1/gcs/platform-data-goog/event_banners/194111354_342550107391493_5395835624479341848_n.jpg',
                  //     );
                  //
                  //     final dummyUser = appUser;
                  //
                  //     context.goNamed(
                  //       EventDetailScreen.id,
                  //       extra: {
                  //         'event': dummyEvent,
                  //         'appUser': dummyUser,
                  //       },
                  //     );
                  //   },
                  //   child: Text("Test Navigate to EventDetailScreen"),
                  // ),

                  CarouselSlider(
                    options: CarouselOptions(
                      onPageChanged: (index, reason) {
                        setState(() {
                          currentIndex = index;
                        });
                      },
                      aspectRatio: 1.8,
                      viewportFraction: 1,
                      enlargeCenterPage: true,
                    ),
                    // items: events.map((event) {
                    //   return Builder(
                    //     builder: (BuildContext context) {
                    //       return GestureDetector(
                    //         behavior: HitTestBehavior.opaque,
                    //         onTap: () async {
                    //           debugPrint('== Carousel Event Tapped ==');
                    //           debugPrint(
                    //               'User conferenceId: ${appUser.conferenceId}');
                    //           final userConferenceIds =
                    //               List<String>.from(appUser.conferenceId ?? [])
                    //                   .map((id) => id.trim())
                    //                   .toList();
                    //           final currentEventId =
                    //               event.eventId.toString().trim();
                    //
                    //           print('User conference IDs: $userConferenceIds');
                    //           print('Event ID: $currentEventId');
                    //           if (userConferenceIds.contains(currentEventId)) {
                    //             try {
                    //               final eventProvider =
                    //                   Provider.of<EventProvider>(context,
                    //                       listen: false);
                    //               final fetchedEvent = await eventProvider
                    //                   .fetchEventById(currentEventId);
                    //
                    //               if (fetchedEvent != null) {
                    //                 Get.to(() => EventDetailScreen(
                    //                       event: fetchedEvent,
                    //                       appUser: appUser,
                    //                     ));
                    //               } else {
                    //                 ScaffoldMessenger.of(context).showSnackBar(
                    //                     SnackBar(
                    //                         content: Text(
                    //                             "Failed to fetch event details")));
                    //               }
                    //             } catch (e) {
                    //               ScaffoldMessenger.of(context).showSnackBar(
                    //                   SnackBar(
                    //                       content: Text("An error occurred")));
                    //             }
                    //           } else {
                    //             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    //                 content: Text(
                    //                     "You do not have access top this conference")));
                    //           }
                    //         },
                    //         child: EventCard(
                    //             event: event,
                    //             showDate: false,
                    //             appUser: appUser),
                    //       );
                    //     },
                    //   );
                    // }).toList(),
                    items: events.map((event) {
                      return EventCard(
                        event: event,
                        showDate: false,
                        appUser: appUser,
                        onTap: () async {
                          debugPrint('== Carousel Event Tapped ==');
                          debugPrint(
                              'User conferenceId: ${appUser.conferenceId}');
                          final userConferenceIds =
                              List<String>.from(appUser.conferenceId ?? [])
                                  .map((id) => id.trim())
                                  .toList();
                          final currentEventId =
                              event.eventId.toString().trim();

                          print('User conference IDs: $userConferenceIds');
                          print('Event ID: $currentEventId');
                          if (userConferenceIds.contains(currentEventId)) {
                            try {
                              final eventProvider = Provider.of<EventProvider>(
                                  context,
                                  listen: false);
                              final fetchedEvent = await eventProvider
                                  .fetchEventById(currentEventId);
                              // if(!context.mounted) return;
                              if (fetchedEvent != null) {
                                // Get.to(() => EventDetailScreen(
                                //       event: fetchedEvent,
                                //       appUser: appUser,
                                //     ));
                                context.pushNamed(
                                  EventDetailScreen.id,
                                  // Ensure this matches your route name
                                  extra: {
                                    'event': fetchedEvent,
                                    'appUser': appUser,
                                  },
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            "Failed to fetch event details")));
                              }
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("An error occurred")));
                            }
                          } else {
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "You do not have access to this conference")));
                          }
                        },
                      );
                    }).toList(),
                  ),
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
                            event: event,
                            showDate: true,
                            appUser: appUser,
                    onTap: () async {
                      debugPrint('== Carousel Event Tapped ==');
                      debugPrint(
                          'User conferenceId: ${appUser.conferenceId}');
                      final userConferenceIds =
                      List<String>.from(appUser.conferenceId ?? [])
                          .map((id) => id.trim())
                          .toList();
                      final currentEventId =
                      event.eventId.toString().trim();

                      print('User conference IDs: $userConferenceIds');
                      print('Event ID: $currentEventId');
                      if (userConferenceIds.contains(currentEventId)) {
                        try {
                          final eventProvider =
                          Provider.of<EventProvider>(context,
                              listen: false);
                          final fetchedEvent = await eventProvider
                              .fetchEventById(currentEventId);
                          // if(!context.mounted) return;
                          if (fetchedEvent != null) {
                            // Get.to(() => EventDetailScreen(
                            //       event: fetchedEvent,
                            //       appUser: appUser,
                            //     ));
                            context.pushNamed(
                              EventDetailScreen.id, // Ensure this matches your route name
                              extra: {
                                'event': fetchedEvent,
                                'appUser': appUser,
                              },
                            );

                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(
                                        "Failed to fetch event details")));
                          }
                        } catch (e) {
                          if(!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text("An error occurred")));
                        }
                      } else {
                        if(!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "You do not have access to this conference")));
                      }
                    },
                          ))
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
