import 'package:dio/dio.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';
// import 'package:inner_crew_user_app/modules/auth/services/authentication_provider.dart';impor

// import '../services/logger.dart';
import '../../services/logger.dart';
// import '../services/repositories.dart';
import '../../../core/serviceLocator.dart';
import 'error_handler_service.dart';
import 'interceptor/refresh_token_interceptor.dart';
import 'model.dart';
import 'network_configuration.dart';

class ApiNetworkingLayer {
  late Dio _dio;
  late Duration _timeoutDuration;

  ApiNetworkingLayer() {
    _dio = Dio();
    _timeoutDuration = NetworkConfiguration.timeoutDuration;
    _dio.interceptors.add(RefreshTokenInterceptor());
    // _dio.interceptors.add(
    //   RefreshTokenInterceptorV2(
    //     authProvider: serviceLocator<AuthenticationProvider>(),
    //     dio: _dio,
    //   ),
    // );
  }

  Future<ApiResponseGeneric> makeRequest<T>(
    RequestType type,
    String urlExt, {
    dynamic body,
    bool hasToken = false,
  }) async {
    final Options options = _generateOptions(
      type.name,
      hasToken,
    );

    return await _dioRequest<T>(
      urlExt,
      options,
      body: body,
    );
  }

  Future<ApiResponseGeneric> _dioRequest<T>(
    String urlExt,
    Options options, {
    dynamic body,
  }) async {
    String url = NetworkConfiguration.baseUrl + urlExt;
    try {
      Response response = await _dio
          .request<T>(
            url,
            data: body,
            options: options,
          )
          .timeout(_timeoutDuration);

      Logger.logSuccess(url);
      return ApiResponseGeneric.fromResponse(response);
    } catch (e) {
      Logger.logError(url);
      return CustomExceptionHandler().handleException(e);
    }
  }

  Options _generateOptions(
    String method,
    bool hasToken,
  ) {
    Map<String, String> headers = {};

    String? token = serviceLocator<AuthenticationProvider>().authToken();
    if (hasToken && token != null && token.isNotEmpty) {
      headers['Authorization'] = token;
    }

    return Options(
      method: method,
      headers: headers,
      contentType: Headers.jsonContentType,
    );
  }
}
