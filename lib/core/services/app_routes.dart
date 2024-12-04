import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/modules/events/screens/home_screen.dart';
import 'package:my_test_app_flavors/modules/events/screens/ticket_screen.dart';
import 'package:my_test_app_flavors/modules/events/speakers/screens/meeting_request_screen.dart';
import 'package:my_test_app_flavors/modules/events/speakers/screens/speaker_profile.dart';
import 'package:my_test_app_flavors/modules/events/speakers/screens/speakers_screen.dart';
import 'package:provider/provider.dart';
import '../../modules/auth/screens/forget_password_screen.dart';
import '../../modules/auth/screens/login_screen.dart';
import '../../modules/auth/screens/signup_screen.dart';
import '../../modules/auth/screens/user_details_screen.dart';
import '../../modules/auth/services/app_user.dart';
import '../../modules/auth/services/auth_provider.dart';
import '../../modules/events/attandees/screens/edit_profile_screen.dart';
import '../../modules/events/screens/event_detail_screen.dart';
import '../../modules/events/swipe and connect/screens/perferences_screen.dart';
import '../../modules/events/swipe and connect/screens/swipe_and_connect.dart';
import '../../modules/navigation/navigation.dart';
import '../../modules/screens/contact_us.dart';
import '../../modules/events/services/event_model.dart';

class AppRoutes {
  static final rootNavigatorKey = GlobalKey<NavigatorState>();
  static final shellNavigatorAKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellA');
  static final shellNavigatorBKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellB');
  static final shellNavigatorCKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellC');
  static final shellNavigatorDKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellD');
  static final shellNavigatorEKey =
      GlobalKey<NavigatorState>(debugLabel: 'shellE');

  static final router = GoRouter(
    initialLocation: '/${SignupScreen.id}',
    navigatorKey: rootNavigatorKey,
    routes: [
      GoRoute(
        name: SignupScreen.id,
        path: '/${SignupScreen.id}',
        builder: (context, state) => SignupScreen(),
        redirect: (context, state) {
          final authProv =
              Provider.of<AuthenticationProvider>(context, listen: false);
          return authProv.appUser != null ? '/${HomeScreen.id}' : null;
        },
      ),
      GoRoute(
        path: '/${UserDetailsScreen.id}',
        name: UserDetailsScreen.id,
        builder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>;
          final Map<String, dynamic> signupData =
              extra['signupData'] as Map<String, dynamic>;
          final bool isGoogleSignIn = extra['isGoogleSignIn'] as bool? ?? false;
          return UserDetailsScreen(
              signupData: signupData, isGoogleSignIn: isGoogleSignIn);
        },
      ),
      GoRoute(
        path: '/${LoginScreen.id}',
        name: LoginScreen.id,
        builder: (context, state) => LoginScreen(),
        routes: [
          GoRoute(
            path: ForgetPasswordPage.id,
            name: ForgetPasswordPage.id,
            builder: (context, state) => ForgetPasswordPage(),
          ),
        ],
      ),
      GoRoute(
        name: EventDetailScreen.id,
        path: '/${EventDetailScreen.id}',
        pageBuilder: (context, state) {
          final args = state.extra as Map<String, dynamic>;
          final event = args['event'] as EventModel;
          final appUser = args['appUser'] as AppUser;
          return MaterialPage(
            child: EventDetailScreen(event: event, appUser: appUser),
          );
        },
        routes: [
          GoRoute(
            name: SpeakersScreen.id,
            path: SpeakersScreen.id,
            builder: (context, state) => SpeakersScreen(),
            routes: [
              GoRoute(
                name: SpeakerProfile.id,
                path: SpeakerProfile.id,
                builder: (context, state) {
                  final speaker =
                      (state.extra as Map<String, dynamic>)['speaker'];
                  return SpeakerProfile(speaker: speaker);
                },
              ),
              GoRoute(
                name: MeetingRequestScreen.id,
                path: MeetingRequestScreen.id,
                builder: (context, state) {
                  final speaker =
                      (state.extra as Map<String, dynamic>)['speaker'];
                  return MeetingRequestScreen(speaker: speaker);
                },
              ),
            ],
          ),
          GoRoute(
            path: TicketScreen.id,
            name: TicketScreen.id,
            builder: (context, state) {
              final Map<String, dynamic> args =
                  state.extra as Map<String, dynamic>;
              final AppUser appUser = args['appUser'];
              final EventModel eventModel = args['eventModel'];
              return TicketScreen(
                appUser: appUser,
                eventModel: eventModel,
              );
            },
          ),
          GoRoute(
            name: SwipeAndConnectScreen.id,
            path: SwipeAndConnectScreen.id,
            builder: (context, state) => SwipeAndConnectScreen(),
            routes: [
              GoRoute(
                name: PreferencesScreen.id,
                path: PreferencesScreen.id,
                builder: (context, state) => PreferencesScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        name: EditProfileScreen.id,
        path: '/${EditProfileScreen.id}',
        builder: (context, state) => EditProfileScreen(),
      ),
      GoRoute(
        path: '/${ContactSupport.id}',
        name: ContactSupport.id,
        builder: (context, state) => ContactSupport(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return NavigationScreen(
            navigationShell: navigationShell,
          );
        },
        branches: [
          StatefulShellBranch(
            navigatorKey: shellNavigatorAKey,
            routes: [
              GoRoute(
                path: '/${HomeScreen.id}',
                name: HomeScreen.id,
                builder: (context, state) => HomeScreen(),
                routes: [],
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
