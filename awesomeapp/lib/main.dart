import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_test_app_flavors/core/serviceLocator.dart';
import 'package:my_test_app_flavors/modules/events/services/event_provider.dart';
import 'package:my_test_app_flavors/modules/events/ticket/services/ticket_provider.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_theme.dart';
import 'core/services/hive_services.dart';
import 'modules/events/swipe and connect/services/swipe_connect_provider.dart';
import 'modules/auth/services/auth_provider.dart';
import 'modules/events/attandees/services/profile_provider.dart';
import 'modules/events/speakers/services/speaker_provider.dart';
import 'modules/navigation/navigation_provider.dart';
import 'core/services/app_routes.dart';

import 'package:my_test_app_flavors/development/firebase_options.dart'
    as dev_options;
import 'package:my_test_app_flavors/staging/firebase_options.dart'
    as stg_options;
import 'package:my_test_app_flavors/production/firebase_options.dart'
    as prod_options;
import 'modules/services/connections_provider.dart';

Future<void> main() async {
  await Hive.initFlutter();
  await HiveService.init();
  WidgetsFlutterBinding.ensureInitialized();

  const bool isProduction = bool.fromEnvironment('dart.vm.product');
  const bool isStaging = bool.fromEnvironment('FLAVOR_STAGING');
  const bool isDevelopment = !isProduction && !isStaging;

  FirebaseOptions firebaseOptions;
  ServiceLocator();

  if (isProduction) {
    firebaseOptions = prod_options.DefaultFirebaseOptions.currentPlatform;
    print('🚀 Running in **PRODUCTION** mode');
  } else if (isStaging) {
    firebaseOptions = stg_options.DefaultFirebaseOptions.currentPlatform;
    print('🧪 Running in **STAGING** mode');
  } else {
    firebaseOptions = dev_options.DefaultFirebaseOptions.currentPlatform;
    print('👨‍💻 Running in **DEVELOPMENT** mode');
  }

  await Firebase.initializeApp(
    options: dev_options.DefaultFirebaseOptions.currentPlatform,
  );

  final authProvider = AuthenticationProvider();
  await authProvider.loadUserFromHive();

  runApp(App(authProvider: authProvider));
}

class App extends StatelessWidget {
  final AuthenticationProvider authProvider;

  const App({super.key, required this.authProvider});

  Future<void> _loadUser(BuildContext context) async {
    final savedUser = await HiveService().getUser();
    if (savedUser != null) {
      Provider.of<AuthenticationProvider>(context, listen: false)
          .updateUser(savedUser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _loadUser(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // Can use a splash screen or loader here
            return const MaterialApp(
              home: Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }
          return MultiProvider(
            providers: [
              ChangeNotifierProvider.value(value: authProvider),
              ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
              ChangeNotifierProvider(create: (_) => ConnectionsProvider()),
              ChangeNotifierProvider(create: (_) => SwipeAndConnectProvider()),
              ChangeNotifierProvider(create: (_) => EventProvider()),
              ChangeNotifierProvider(create: (_) => ProfileProvider()),
              ChangeNotifierProvider(create: (_) => NavigationProvider()),
              ChangeNotifierProvider(create: (_) => SpeakerProvider()),
              ChangeNotifierProvider(create: (_) => TicketProvider()),
            ],
            child: ScreenUtilInit(
              designSize: const Size(375, 812),
              builder: (context, child) {
                return MaterialApp.router(
                  theme: theme(context),
                  debugShowCheckedModeBanner: false,
                  routeInformationProvider:
                      AppRoutes.router.routeInformationProvider,
                  routeInformationParser:
                      AppRoutes.router.routeInformationParser,
                  routerDelegate: AppRoutes.router.routerDelegate,
                );
              },
            ),
          );
        });
  }
}
