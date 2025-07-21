import 'package:my_test_app_flavors/core/serviceLocator.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';
import '../../../core/constants/dio_client.dart';
import '../../../core/services/hive_services.dart';
import 'event_model.dart';
import '../../../core/constants/api_constants.dart';
import 'package:dio/dio.dart' as dio;

class EventNetworking {
  static Future<List<EventModel>> fetchEvents() async {
    final url = ApiConstants.baseUrl + ApiConstants.allEvents;
    print('Requesting events from: $url');

    try {
      // final token = await serviceLocator<AuthenticationProvider>().authToken();
      final token = await HiveService().getAccessToken();
      print("Access Token from hive: $token");
      final dioInstance = DioClient.getDioInstance();
      final response = await dioInstance.get(url,
          options: dio.Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ));
      print('Status Code: ${response.statusCode}, ${response.data}');
      if (response.statusCode == 200) {
        // Check if the response data is a list
        if (response.data['data']["conferences"] is List) {
          final List<dynamic> data = response.data["data"]["conferences"];
          return data.map((e) => EventModel.fromJson(e)).toList();
        } else {
          throw Exception('Failed to load events');
        }
      } else {
        throw Exception('Failed to load events 1');
      }
    } catch (e) {
      print('Error fetching events: $e');
      throw e;
    }
  }

  static Future<EventModel> fetchEventById(eventId) async {
    final url = ApiConstants.baseUrl + "/api/conference/$eventId";
    print("Url: ${url}");
    print("EventId: ${eventId}");
    try {
      final token = await serviceLocator<AuthenticationProvider>().authToken();
      final dioInstance = DioClient.getDioInstance();
      print(token);

      final response = await dioInstance.get(url,
          options: dio.Options(headers: {
            "Authorization": "Bearer $token",
          }));
      print(response.data); // Log the raw response

      if (response.statusCode == 200 && response.data != null) {
        final eventData = response.data['data']['conference'];
        if (eventData == null) {
          throw Exception('Event data is null');
        }
        return EventModel.fromJson(eventData);
      } else {
        throw Exception("Failed to fetch event by Id");
      }
    } catch (e) {
      print("Error fetching event by ID: $e");
      throw Exception('Failed to fetch event: $e');
    }
  }
}
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'event_model.dart';

// class EventNetworking {
//   static Future<List<EventModel>> fetchEvents() async {
//     final querySnapshot =
//         await FirebaseFirestore.instance.collection('conferences').get();
//     List<EventModel> events = querySnapshot.docs
//         .map((doc) => EventModel.fromJson(doc.data()))
//         .toList();

//     return events;
//   }
// }on