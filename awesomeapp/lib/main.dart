import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:my_test_app_flavors/modules/events/services/event_provider.dart';
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

  // const bool isProduction = bool.fromEnvironment('dart.vm.product');
  // const bool isStaging = bool.fromEnvironment('FLAVOR_STAGING');
  // const bool isDevelopment = !isProduction && !isStaging;

  // FirebaseOptions firebaseOptions;

  // if (isProduction) {
  //   firebaseOptions = prod_options.DefaultFirebaseOptions.currentPlatform;
  // } else if (isStaging) {
  //   firebaseOptions = stg_options.DefaultFirebaseOptions.currentPlatform;
  // } else {
  //   firebaseOptions = dev_options.DefaultFirebaseOptions.currentPlatform;
  // }

  await Firebase.initializeApp(
    options: dev_options.DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => ConnectionsProvider()),
        ChangeNotifierProvider(create: (_) => SwipeAndConnectProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => SpeakerProvider()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        builder: (context, child) {
          return MaterialApp.router(
            theme: theme(context),
            debugShowCheckedModeBanner: false,
            routeInformationProvider: AppRoutes.router.routeInformationProvider,
            routeInformationParser: AppRoutes.router.routeInformationParser,
            routerDelegate: AppRoutes.router.routerDelegate,
          );
        },
      ),
    );
  }
}
