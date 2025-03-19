import 'package:dio/dio.dart';
import '../services/hive_services.dart';
import '../interceptors/refreshTokenInterceptor.dart';

class DioClient{
  static final Dio _dio = Dio();
  static Dio getDioInstance(){
    final hiveService = HiveService();
    _dio.interceptors.add(Refreshtokeninterceptor(_dio, hiveService));
    // _dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return _dio;
  }
}
