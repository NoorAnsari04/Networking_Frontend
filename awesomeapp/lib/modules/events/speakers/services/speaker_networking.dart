import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_test_app_flavors/core/constants/dio_client.dart';
import 'package:my_test_app_flavors/core/serviceLocator.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_networking.dart';
import 'package:dio/dio.dart' as dio;
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';
import '../../../../core/constants/api_constants.dart';
import 'meeting_request_model.dart';

class SpeakerNetworking {
  // final Dio _dio = Dio();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<bool> isUserSpeaker(String userId) async {
    try {
      QuerySnapshot speakerSnapshot = await _firestore
          .collection('speakers')
          .where('userId', isEqualTo: userId)
          .get();
      return speakerSnapshot.docs.isNotEmpty;
    } catch (e) {
      print('Error checking if user is speaker: $e');
      return false;
    }
  }

  Future<List<AppUser>> fetchSpeakersByEventId(String eventId) async {
    // try {
    //   String currentUserId = _auth.currentUser?.uid ?? '';
    //   print("Fetching speakers for current user ID: $currentUserId");
    //   QuerySnapshot speakersSnapshot =
    //       await _firestore.collection('speakers').get();
    //   List<AppUser> speakers = [];
    //   for (var doc in speakersSnapshot.docs) {
    //     final sid = (doc.data() as Map<String, dynamic>)['userId'];
    //     if (sid != currentUserId) {
    //       Map<String, dynamic>? speakerDoc =
    //           await AuthNetworking().getUserDocument(sid);
    //       if (speakerDoc != null) {
    //         AppUser speaker = AppUser.fromJson(speakerDoc);
    //         speaker.id = sid;
    //         speakers.add(speaker);
    //       }
    //     }
    //   }
    //   return speakers;
    // } catch (e) {
    //   print("Error fetching speakers: $e");
    //   return [];
    // }
    final url = ApiConstants.baseUrl + '/api/speaker/$eventId';
    try {
      String? token = serviceLocator<AuthenticationProvider>().authToken();
      final dioInstance = DioClient.getDioInstance();
      print(token);

      final response = await dioInstance.get(url,
          options: dio.Options(headers: {
            "Authorization": "Bearer: $token",
          }));
      print(response.data);

      if (response.statusCode == 200 && response.data != null) {
        final Map<String, dynamic> responseData = response.data;
        final List<dynamic> speakersData = responseData['data']['speakers'];
        return speakersData.map((json) => AppUser.fromJson(json)).toList();
      } else {
        throw Exception("Failed to fetch speakers by event Id");
      }
    } catch (e) {
      print("Error fetching speakers by event ID: $e");
      throw Exception('Failed to fetch speakers: $e');
    }
  }

  // todo make func of type List<MeetingRequest>
  Future<List<Map<String, dynamic>>> fetchMeetingRequests() async {
    try {
      final url = ApiConstants.baseUrl + ApiConstants.pendingRequests;
      final dioInstance = DioClient.getDioInstance();
      final currentUserId = _auth.currentUser?.uid ?? '';
      print("currentUserId: $currentUserId");

      // Make the API call
      final response = await dioInstance.get(url, queryParameters: {
        'userId': currentUserId,
      });

      // Check if the API call was successful
      if (response.statusCode != 200) {
        throw Exception(
            "Failed to load pending requests: ${response.statusCode}");
      }

      // Parse the response data
      final Map<String, dynamic> responseData = response.data;

      // Check if the API returned any pending requests
      if (!responseData['success'] ||
          responseData['data']['pendingRequests'].isEmpty) {
        throw Exception("No pending requests found");
      }

      // Get the list of pending requests
      final List<dynamic> pendingRequests =
          responseData['data']['pendingRequests'];
      List<Map<String, dynamic>> requests = [];

      // Loop through each pending request
      for (var request in pendingRequests) {
        // Ensure the request is a Map<String, dynamic>
        if (request is Map<String, dynamic>) {
          final Map<String, dynamic> requestMap = request;
          final Map<String, dynamic> senderDetails =
              requestMap['sender'] as Map<String, dynamic>;

          // Add the request to the list
          requests.add({
            'request': {
              ...requestMap, // Include all fields from the request
              'id': requestMap['_id'], // Use '_id' as the request ID
            },
            'user': senderDetails,
          });
        }
      }

      // Return the list of requests
      return requests;
    } catch (error) {
      print("Error fetching requests: $error");
      throw error;
    }
  }

  // Future<void> acceptMeetingRequest(
  //     String requestId, String senderId, String receiverId) async {
  //   try {
  //     await _firestore
  //         .collection('meeting_requests')
  //         .doc(requestId)
  //         .update({'status': 'accepted'});
  //
  //     await _firestore.collection('connections').add({
  //       'accepted': receiverId,
  //       'sent': senderId,
  //       'date': Timestamp.now(),
  //     });
  //   } catch (e) {
  //     print('Error accepting meeting request: $e');
  //     throw e;
  //   }
  // }
  //
  // Future<void> rejectMeetingRequest(String requestId) async {
  //   try {
  //     await _firestore
  //         .collection('meeting_requests')
  //         .doc(requestId)
  //         .update({'status': 'rejected'});
  //   } catch (e) {
  //     print('Error rejecting meeting request: $e');
  //     throw e;
  //   }
  // }

  Future<void> handleMeetingRequest({
    required String requestId,
    required String senderId,
    required String receiverId,
    required String action,
  }) async {
    try {
      final dioInstance = DioClient.getDioInstance();
      final url = ApiConstants.baseUrl + ApiConstants.handleConnectionRequests;

      final response = await dioInstance.put(url, data: {
        'requestId': requestId,
        'action': action,
      });

      if (response.statusCode != 200) {
        throw Exception(
            "Failed to handle meeting request: ${response.statusCode}");
      }

      final Map<String, dynamic> responseData = response.data;
      if (!responseData['success']) {
        throw Exception(
            responseData['message'] ?? "Failed to handle meeting request");
      }

      if (action == 'Approve') {
        await _firestore.collection('connections').add({
          'accepted': receiverId,
          'sent': senderId,
          'date': Timestamp.now(),
        });
      }
    } catch (e) {
      print("Error handling meeting request: $e");
      throw e;
    }
  }

  Future<String> getRequestStatus(String receiverId) async {
    try {
      final currentUserId = _auth.currentUser?.uid ?? '';

      QuerySnapshot requestSnapshot = await FirebaseFirestore.instance
          .collection('meeting_requests')
          .where(Filter.or(
              Filter.and(Filter('senderId', isEqualTo: currentUserId),
                  Filter('receiverId', isEqualTo: receiverId)),
              Filter.and(Filter('senderId', isEqualTo: receiverId),
                  Filter('receiverId', isEqualTo: currentUserId))))
          .get();

      if (requestSnapshot.docs.isNotEmpty) {
        final request =
            requestSnapshot.docs.first.data() as Map<String, dynamic>;
        return request['status'];
      }

      return 'none';
    } catch (e) {
      print('Error getting request status: $e');
      return 'error';
    }
  }

  Future<void> createMeetingRequest(MeetingRequest request) async {
    try {
      await _firestore.collection('meeting_requests').add(request.toJson());
    } catch (e) {
      print('Error creating meeting request: $e');
      throw e;
    }
  }
}
