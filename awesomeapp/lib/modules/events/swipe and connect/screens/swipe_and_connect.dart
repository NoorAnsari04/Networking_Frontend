import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/extensions/scaffold_message.dart';
import 'package:provider/provider.dart';
import 'package:my_test_app_flavors/core/constants/icon_constants.dart';
import '../../../../core/services/helper_function.dart';
import '../../../auth/services/app_user.dart';
import '../../services/event_model.dart';
import '../components/attandee_card.dart';
import '../../components/swipe_widget.dart';
import '../components/background_connect_widget.dart';
import '../services/swipe_connect_provider.dart';
import 'perferences_screen.dart';

class SwipeAndConnectScreen extends StatefulWidget {
  static const id = 'swipeAndConnectScreen';
  final EventModel event;

  SwipeAndConnectScreen({required this.event});

  @override
  _SwipeAndConnectScreenState createState() => _SwipeAndConnectScreenState();
}

class _SwipeAndConnectScreenState extends State<SwipeAndConnectScreen> {
  late final PageController _pageController;
  final ValueNotifier<double> offsetXNotifier = ValueNotifier(0.0);
  final ValueNotifier<Color> _color = ValueNotifier(Colors.green);
  final ValueNotifier<bool> isInvitation = ValueNotifier(false);
  final ValueNotifier<bool> showSecondCard = ValueNotifier(true);

  bool isAccepting = false;

  // Validate conferenceId
  bool isValidConferenceId(String conferenceId) {
    return conferenceId.length == 24 &&
        RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(conferenceId);
  }

  @override
  void dispose() {
    offsetXNotifier.dispose();
    isInvitation.dispose();
    showSecondCard.dispose();
    _pageController.dispose();
    super.dispose();
  }

  bool _isLoadingInterests = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 1);
    final provider =
        Provider.of<SwipeAndConnectProvider>(context, listen: false);
    provider.loadUsers(widget.event.eventId);
    // Validate conferenceId before loading users
    if (!isValidConferenceId(widget.event.eventId)) {
      print("Invalid conferenceId: ${widget.event.eventId}");
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // provider.loadUsers(widget.event.eventId,
      //     profession: 'profession', industry: 'industry');
      // Also load interests if not already loaded
      setState(() => _isLoadingInterests = true);
      try {
        await provider.loadInterests();
        await provider.loadUsers(widget.event.eventId,
            profession: 'profession', industry: 'industry');
        print("Finished loading interests and users");
      } catch (e) {
        print("Error in initialization: $e");
      } finally {
        setState(() => _isLoadingInterests = false);
      }
    });
  }

  void onDxChange(double vl) {
    isAccepting = !vl.isNegative;
    offsetXNotifier.value = vl.isNegative ? (vl * -0.005) : (vl * 0.005);
    _color.value = vl.isNegative ? Colors.red : Colors.green;

    // Hide second card when swiping
    if (vl.abs() > 50) {
      showSecondCard.value = false;
    } else {
      showSecondCard.value = true;
    }
  }

  List<String> getInterestNames(AppUser user) {
    if (user.interestNames != null && user.interestNames!.isNotEmpty) {
      return user.interestNames!;
    }

    if (user.interests != null && user.interests!.isNotEmpty) {
      final provider =
          Provider.of<SwipeAndConnectProvider>(context, listen: false);
      return user.interests!
          .map((id) => provider.interestsMap[id] ?? 'Interest: $id')
          .toList();
    }

    return ['General'];
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          body: Consumer<SwipeAndConnectProvider>(
            builder: (context, provider, _) {
              if (provider.isLoading || _isLoadingInterests) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else if (provider.attendees.isEmpty) {
                return const Center(
                  child: Text('No more users available'),
                );
              } else {
                return Column(
                  children: [
                    50.height,
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: EdgeInsets.all(20.0.w),
                            child: SvgPicture.asset(
                              'assets/backward_arrow_head.svg',
                              height: 25.h,
                              width: 15.w,
                            ),
                          ),
                        ),
                        SizedBox(width: 250.w),
                        GestureDetector(
                          onTap: () async {
                            final result = await context.pushNamed(PreferencesScreen.id);
                            if(result != null && result is Map){
                              final profession = result['profession'];
                              final industry = result['industry'];
                              final provider = Provider.of<SwipeAndConnectProvider>(context, listen: false);
                              provider.loadUsers(widget.event.eventId, profession: profession, industry: industry);
                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: SvgPicture.asset(
                              IconConstants.filterIcon,
                              height: 30.h,
                              width: 20.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: PageView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {},
                          allowImplicitScrolling: false,
                          itemCount: provider.attendees.length,
                          controller: _pageController,
                          itemBuilder: (context, index) {
                            final user = provider.attendees[index];
                            final interestNames = getInterestNames(user);
                            return ValueListenableBuilder<double>(
                              valueListenable: offsetXNotifier,
                              builder: (context, offsetX, child) {
                                return Stack(
                                  children: [
                                    if ((index + 1) < provider.attendees.length)
                                      BackgroundConnectWidget(
                                        connect: provider.attendees[index + 1],
                                        opacity: offsetX.clamp(0.0, 1.0),
                                        color: _color.value,
                                        showSecondCard: showSecondCard.value,
                                        conferenceId: widget.event.eventId,
                                      ),
                                    SwipeWidget(
                                      onChange: onDxChange,
                                      onActionPerformed: (vl) {
                                        if (vl > 200) {
                                          provider.swipeAndConnectAction(
                                              receiverId:
                                                  provider.attendees[index].id,
                                              action: true,
                                              conferenceId:
                                                  widget.event.eventId);
                                          if (provider.attendees[index]
                                              .isReceivedRequest) {
                                            HelperFunction.showToast(
                                                'You both are connected now');
                                          } else {
                                            context
                                                .showSnackBar('Request sent');
                                          }
                                        } else if (vl < -200) {
                                          provider.swipeAndConnectAction(
                                              receiverId:
                                                  provider.attendees[index].id,
                                              action: false,
                                              conferenceId:
                                                  widget.event.eventId);
                                          context
                                              .showSnackBar('User skipped');
                                        }
                                        showSecondCard.value = true;
                                      },
                                      child: ValueListenableBuilder<bool>(
                                        valueListenable: showSecondCard,
                                        builder: (context, showSecond, _) {
                                          return AttendeeCard(
                                            imageUrl: provider
                                                .attendees[index].imageUrl,
                                            name:
                                                provider.attendees[index].name,
                                            lastName: provider
                                                .attendees[index].lastName,
                                            isStudent: provider.attendees[index]
                                                    .userType ==
                                                'Student',
                                            company: provider.attendees[index]
                                                        .userType ==
                                                    'Student'
                                                ? provider.attendees[index]
                                                        .instituteName ??
                                                    ''
                                                : provider.attendees[index]
                                                        .company ??
                                                    '',
                                            position: provider.attendees[index]
                                                        .userType ==
                                                    'Student'
                                                ? provider.attendees[index]
                                                        .degreeProgram ??
                                                    ''
                                                : provider.attendees[index]
                                                        .position ??
                                                    '',
                                            interests: interestNames,
                                            // Use the interest names instead of IDs
                                            description: provider
                                                    .attendees[index]
                                                    .description ??
                                                '',
                                            onSkip: () {
                                              provider.swipeAndConnectAction(
                                                  receiverId: provider
                                                      .attendees[index].id,
                                                  action: false,
                                                  conferenceId:
                                                      widget.event.eventId);
                                              context.showSnackBar(
                                                  'User Skipped');
                                            },
                                            onConnect: () {
                                              provider.swipeAndConnectAction(
                                                  receiverId: provider
                                                      .attendees[index].id,
                                                  action: true,
                                                  conferenceId:
                                                      widget.event.eventId);
                                              if (provider.attendees[index]
                                                  .isReceivedRequest) {
                                                HelperFunction.showToast(
                                                    'You both are connected now');
                                              } else {
                                                context.showSnackBar(
                                                    'Request sent');
                                              }
                                            },
                                            showSecondCard: showSecond,
                                            isReceivedRequest: provider
                                                .attendees[index]
                                                .isReceivedRequest,
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
