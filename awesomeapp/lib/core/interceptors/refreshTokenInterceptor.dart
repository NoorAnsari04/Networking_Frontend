import 'package:dio/dio.dart';
import 'package:my_test_app_flavors/core/constants/api_constants.dart';
import '../services/hive_services.dart';

class Refreshtokeninterceptor extends Interceptor {
  final Dio dio;
  final HiveService hiveService;

  Refreshtokeninterceptor(this.dio, this.hiveService);

  @override
  Future<void> onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final user = hiveService.getUser();
    final accessToken = hiveService.getAccessToken();

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return super.onRequest(options, handler);
  }

  @override
  Future<void> onResponse(
      Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      print('Access token expired. Attempting to refresh....');
      final user = hiveService.getUser();
      final refreshToken = user?.refreshToken;

      if (refreshToken != null) {
        try {
          final refreshResponse = await dio.post(
              ApiConstants.baseUrl + ApiConstants.refreshToken,
              data: {'refresh_token': refreshToken});

          if (refreshResponse.statusCode == 200 && refreshResponse.data['access_token'] != null) {
            print("Token refreshed successfully");
            final newAccessToken = refreshResponse.data['access_token'];
            final newRefreshToken = refreshResponse.data['refresh_token'];
            final updatedUser = user?.copyWith(accessToken: newAccessToken);
            hiveService.saveUser(updatedUser!);
            if (newRefreshToken != null) {
              await hiveService.saveRefreshToken(newRefreshToken);
            }
            // final retryOptions = response.requestOptions.copyWith(
            //   headers: {'Auhorization': 'Bearer $newAccessToken'},
            // );
            final options = response.requestOptions;
            final retryResponse = await dio.request(
              options.path,
              // response.requestOptions.path,
              options: Options(
                method: options.method,
                headers: {
                  ...options.headers,
                  'Authorization': 'Bearer $newAccessToken',
                },
              ),
              data: options.data,
              queryParameters: options.queryParameters,
            );
            return handler.resolve(retryResponse);
            // final retryOptions = Options(
            //   method: response.requestOptions.method,
            //   headers: {
            //     ...response.requestOptions.headers,
            //     'Authorization': 'Bearer $newAccessToken',
            //   }
            // );
            // await dio.request(
            //   response.requestOptions.path,
            //   options: retryOptions,
            //   data:  response.requestOptions.data,
            //   queryParameters: response.requestOptions.queryParameters
            // );
          } else {
            print("Failed to refresh roken");
          }
        } catch (e) {
          return handler.reject(DioException(
              requestOptions: response.requestOptions,
              error: 'Unable to refresh token'));
        }
      }
    }
    return super.onResponse(response, handler);
  }

  @override 
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async{
    return super.onError(err, handler);
  }
}
