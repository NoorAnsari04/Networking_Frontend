
import 'package:dio/dio.dart' as dio;
import 'package:my_test_app_flavors/core/constants/api_constants.dart';
import 'package:my_test_app_flavors/core/constants/dio_client.dart';
import 'package:my_test_app_flavors/core/serviceLocator.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';

class TicketNetworking {
  // final Dio _dio = Dio();
  Future<Map<String, dynamic>> getTicketDetails(String eventId) async {
    final url = ApiConstants.baseUrl + '/api/ticket/$eventId';
    try {
      final token = await serviceLocator<AuthenticationProvider>().authToken();
      final dioInstance = DioClient.getDioInstance();

      final response = await dioInstance.post(url,
          options: dio.Options(headers: {"Authorization": "Bearer $token"}));
      print(response.data);

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception('Failed to load ticket details');
      }
    } catch (e) {
      print("Error fetching ticket details: $e");
      throw Exception('Error fetching ticket details');
    }
  }
}
