import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:my_test_app_flavors/core/services/app_routes.dart';
// // import 'package:go_router/go_router.dart';
// import 'package:inner_crew_user_app/modules/auth/screens/login_screen.dart';
// import 'package:inner_crew_user_app/modules/auth/services/authentication_provider.dart';
// import 'package:inner_crew_user_app/modules/navigation/navigation_provider.dart';
// import 'package:inner_crew_user_app/modules/notification/services/fcm_provider.dart';
import '../../../../modules/auth/services/auth_provider.dart';
import '../../../../modules/navigation/navigation_provider.dart';
import '../../../../core/serviceLocator.dart';

// import '../../services/repositories.dart';

class RefreshTokenInterceptor extends Interceptor {
  bool _isRefreshing = false; // Flag to prevent infinite retries

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (_isAuthenticationError(err)) {
      await _handleAuthenticationError(err, handler);
    } else if (_isAuthorizationError(err)) {
      String accessToken =
          serviceLocator.get<AuthenticationProvider>().authToken() ?? "";
      if (accessToken.isEmpty) {
        super.onError(err, handler);
        return;
      }
      await _signOut();
    } else {
      super.onError(err, handler);
    }
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    super.onResponse(response, handler);
  }

  bool _isAuthenticationError(DioException err) {
    return err.response != null && err.response!.statusCode == 401;
  }

  bool _isAuthorizationError(DioException err) {
    return err.response != null && err.response!.statusCode == 403;
  }

  Future<void> _handleAuthenticationError(
      DioException err, ErrorInterceptorHandler handler) async {
    if (!_isRefreshing) {
      _isRefreshing = true;
      try {
        bool success = await _refreshToken();
        if (success) {
          final response = await _retry(err.requestOptions);
          _isRefreshing = false;
          return handler.resolve(response);
        } else {
          await _signOut();
        }
      } catch (e) {
        _isRefreshing = false;
        // await _signOut();
      }
    } else {
      await _signOut();
    }
  }

  Future<bool> _refreshToken() async {
    //   final refreshToken = await serviceLocator<AuthenticationProvider>().getAuthToken();
    //   final newAccessToken =  serviceLocator<AuthenticationProvider>().getAuthToken(refreshToken);
    //   return newAccessToken != null;
    // }

    // Future<void> _signOut() async {
    //   final fcmProvider = serviceLocator<FCMConfigProvider>();
    //   final success = await serviceLocator<AuthenticationProvider>().signOut(
    //     {
    //       "fcmToken": fcmProvider.token,
    //     },
    //   );
    //   if (success) {
    //     Fluttertoast.showToast(msg: 'Session expired');
    //     final context = serviceLocator<NavigationProvider>().context;
    //     if (context.mounted) context.goNamed(LoginScreen.id);
    //   }
    try {
      final String? refreshToken =
          serviceLocator<AuthenticationProvider>().appUser?.refreshToken;

      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final String? newAccessToken =
          await serviceLocator<AuthenticationProvider>()
              .getAuthToken(refreshToken);

      if (newAccessToken != null && newAccessToken.isNotEmpty) {
        serviceLocator<AuthenticationProvider>().appUser?.accessToken =
            newAccessToken;
        return true;
      }
    } catch (e) {
      print("Error during token refresh: $e");
    }
    return false;
  }

  Future<Response> _retry(RequestOptions requestOptions) async {
    String accessToken = serviceLocator<AuthenticationProvider>().authToken()!;

    final response = await Dio().request(
      requestOptions.path,
      data: requestOptions.data,
      options: Options(
        method: requestOptions.method,
        contentType: Headers.jsonContentType,
        headers: {'Authorization': accessToken},
      ),
    );
    return response;
  }

  Future<void> _signOut() async {
    try {
      final success = await serviceLocator<AuthenticationProvider>().signOut();
      if (success) {
        Fluttertoast.showToast(msg: 'Session expired! Please Login again');

        serviceLocator<NavigationProvider>().navigateToLogin(AppRoutes.rootNavigatorKey.currentContext!);
      }
    } catch (e) {
      print("Error during signout");
    }
  }
}

// class RefreshTokenInterceptorV2 extends Interceptor {
//   final Dio dio;
//   final AuthenticationProvider
//       authProvider; // Service responsible for managing tokens

//   RefreshTokenInterceptorV2({
//     required this.dio,
//     required this.authProvider,
//   });

//   // @override
//   // Future onError(DioException err, ErrorInterceptorHandler handler) async {
//   //   final fcmProvider = serviceLocator<FCMConfigProvider>();
//   //   // Check if status code is 401 (Unauthorized) and not a refresh token request
//   //   if (err.response?.statusCode == 401) {
//   //     // Attempt to refresh the token
//   //     try {
//   //       final isAccessTokenUpdated = await authProvider.getAuthToken();

//   //       // If the token is refreshed, retry the original request with the new token
//   //       if (isAccessTokenUpdated) {
//   //         // Pass the response from the retried request to the handler
//   //         return handler.resolve(await _retry(err.requestOptions));
//   //       } else {
//   //         // If refresh token is null, logout the user
//   //         authProvider.signOut(
//   //           {
//   //             "fcmToken": fcmProvider.token,
//   //           },
//   //         );
//   //       }
//   //     } catch (e) {
//   //       // If refresh fails (e.g., 403 Forbidden), logout the user
//   //       if (err.response?.statusCode == 403) {
//   //         authProvider.signOut(
//   //           {
//   //             "fcmToken": fcmProvider.token,
//   //           },
//   //         );
//   //       }
//   //     }
//   //   }

//   //   // Pass error to the next interceptor if not handled
//   //   return handler.next(err);
//   // }

//   // Future<Response> _retry(RequestOptions requestOptions) async {
//   //   String accessToken = authProvider.authToken!.accessToken;

//   //   final response = await Dio().request(
//   //     requestOptions.path,
//   //     data: requestOptions.data,
//   //     options: Options(
//   //       method: requestOptions.method,
//   //       contentType: Headers.jsonContentType,
//   //       headers: {'Authorization': accessToken},
//   //     ),
//   //   );
//   //   return response;
//   // }
// }
