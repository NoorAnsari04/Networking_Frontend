import 'package:get_it/get_it.dart';
import '../core/services/app_routes.dart';
import '../core/services/helper_function.dart';
import '../core/services/hive_services.dart';
import '../core/services/logger.dart';
import '../core/services/validator.dart';

import '../core/networking/networking/api_networking_layer.dart';
import '../core/networking/networking/error_handler_service.dart';
import '../core/networking/networking/network_configuration.dart';

import '../modules/auth/services/auth_provider.dart';
import '../modules/auth/services/social_networking.dart';

import '../modules/events/services/event_provider.dart';
import '../modules/events/speakers/services/speaker_provider.dart';

import '../modules/navigation/navigation_provider.dart';


final GetIt serviceLocator = GetIt.instance;
void ServiceLocator() {
  serviceLocator.registerLazySingleton<AppRoutes>(() => AppRoutes());
  serviceLocator.registerLazySingleton<HelperFunction>(() => HelperFunction());
  serviceLocator.registerLazySingleton<HiveService>(() => HiveService());
  serviceLocator.registerLazySingleton<Logger>(() => Logger());
  serviceLocator.registerLazySingleton<Validator>(() => Validator());
  serviceLocator.registerLazySingleton<ApiNetworkingLayer>(() => ApiNetworkingLayer());
  serviceLocator.registerLazySingleton<CustomExceptionHandler>(() =>CustomExceptionHandler());
  serviceLocator.registerLazySingleton<NetworkConfiguration>(() => NetworkConfiguration());
  serviceLocator.registerLazySingleton<AuthenticationProvider>(() => AuthenticationProvider());
  serviceLocator.registerLazySingleton<SocialNetworking>(() => SocialNetworking());
  serviceLocator.registerLazySingleton<EventProvider>(() => EventProvider());
  serviceLocator.registerLazySingleton<SpeakerProvider>(() => SpeakerProvider());
  serviceLocator.registerLazySingleton<NavigationProvider>(() => NavigationProvider());

}
