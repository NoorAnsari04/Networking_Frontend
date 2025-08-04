// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_test_app_flavors/core/constants/api_constants.dart';
import 'package:my_test_app_flavors/core/serviceLocator.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';
import '../../../../core/constants/dio_client.dart';
import 'package:dio/dio.dart';

import '../components/dropdown.dart';

class SwipeAndConnectNetworking {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dioInstance = DioClient.getDioInstance();

  Future<Map<String, String>> loadInterests() async {
    final url = ApiConstants.baseUrl + ApiConstants.loadInterests;

    try {
      final token = await serviceLocator<AuthenticationProvider>().authToken();
      final response = await dioInstance.get(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        // return Map<String, String>.from(response.data);
        final List interests = response.data['data']['allInterests'];
        final Map<String, String> interestMap = {
          for (var item in interests)
            item['name'] as String: item['_id'] as String,
        };
        return interestMap;
      }
      throw Exception("Failed to load interests");
    } catch (error) {
      print("Error loading interests: $error");
      throw error;
    }
  }

  Future<List<DropdownOptions>> loadDropdownInterests() async {
    final url = ApiConstants.baseUrl + ApiConstants.loadInterests;

    try {
      final token = await serviceLocator<AuthenticationProvider>().authToken();
      final response = await dioInstance.get(url,
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      if (response.statusCode == 200) {
        // return Map<String, String>.from(response.data);

        var interests=(response.data['data']['allInterests'] as List).map((e)=>DropdownOptions.fromJson(e)).toList();
        print("Loaded ${interests.length} industries.");
        // notifyListeners();
        return interests;
      }
      throw Exception("Failed to load interests");
    } catch (error) {
      print("Error loading interests: $error");
      throw error;
    }
  }

  // Fix the fetchInterestNames method to match the API requirements
  Future<Map<String, String>> fetchInterestNames(List<String> interestIds) async {
    if (interestIds.isEmpty) {
      return {};
    }
    final url = ApiConstants.baseUrl + ApiConstants.fetchInterestName;
    try {
      print(
          "Fetching interest names for ${interestIds.length} IDs: $interestIds");
      final token = await serviceLocator<AuthenticationProvider>().authToken();

      final response = await dioInstance.get(url,
          data: {'interestIds': interestIds},
          options: Options(headers: {'Authorization': 'Bearer $token'}));
      print('API Raw Response: ${response.data}');

      if (response.statusCode == 200) {
        print("Successfully fetched interest names: ${response.data}");
        return Map<String, String>.from(response.data);
      } else {
        print(
            "Failed to load interest names: ${response.statusCode} - ${response.statusMessage}");
        return {};
      }
    } catch (error) {
      print('Error fetching interest names: $error');
      return {};
    }
  }

  Future<List<AppUser>> loadUsers(String conferenceId, {String? userType,String? profession, String? industry}) async {
    final url = ApiConstants.baseUrl + '/api/snc/conference/$conferenceId';
    try {
      if (conferenceId.isEmpty || !isValidConferenceId(conferenceId)) {
        print("Invalid conferenceId: $conferenceId");
        throw Exception("Invalid conferenceId");
      }
      String currentUserId = _auth.currentUser?.uid ?? '';
      print("Loading users for current user ID: $currentUserId");
      final token = await serviceLocator<AuthenticationProvider>().authToken();

      // final response = await dioInstance.get(
      //   url,
      //   // queryParameters: {
      //   //   'userType': profession != null ? 'Industry Person' : 'Student',
      //   //   if (profession != null) 'designation': profession,
      //   //   if (industry != null && industry.isNotEmpty) 'interests': industry,
      //   // },
      //   queryParameters: {
      //     if (userType != null) 'userType': userType,
      //     if (profession != null) 'designation': profession,
      //     if (industry != null && industry.isNotEmpty) 'interests': industry,
      //   },
      //   options: Options(headers: {'Authorization': 'Bearer $token'}),
      // );
      final queryParams = {
        if (userType != null) 'userType': userType,
        if (profession != null) 'designation': profession,
        if (industry != null && industry.isNotEmpty) 'interests': industry,
      };

      print('➡️ URL: $url');
      print('➡️ Query Params: $queryParams');

      final response = await dioInstance.get(
        url,
        queryParameters: queryParams,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        List<AppUser> attendees = [];
        if (data != null &&
            data['data'] != null &&
            data['data']['users'] != null) {
          attendees = (data['data']['users'] as List)
              .map((user) => AppUser.fromJson(user))
              .toList();
          attendees.removeWhere((x) => x.id == currentUserId);

          if (attendees.isNotEmpty) {
            Set<String> allInterestIds = {};
            for (var user in attendees) {
              if (user.interests != null && user.interests!.isNotEmpty) {
                allInterestIds.addAll(user.interests!);
              }
            }
            if (allInterestIds.isNotEmpty) {
              try {
                // Fetch all interest names in one call
                Map<String, String> interestMap =
                    await fetchInterestNames(allInterestIds.toList());

                // Assign interest names to each user
                for (var user in attendees) {
                  if (user.interests != null && user.interests!.isNotEmpty) {
                    user.interestNames = user.interests!
                        .map((id) => interestMap[id] ?? 'Interest: $id')
                        .toList();
                  } else {
                    user.interestNames = [];
                  }
                }
              } catch (e) {
                print("Error mapping interests: $e");
                // Set default interest names if mapping fails
                for (var user in attendees) {
                  if (user.interests != null) {
                    user.interestNames =
                        user.interests!.map((id) => 'Interest: $id').toList();
                  } else {
                    user.interestNames = [];
                  }
                }
              }
            }
          }
        } else {
          print("Unexpected API response structure: $data");
        }

        // Calculate score and sort users
        attendees.forEach((user) {
          user.score = calculateUserScore(user, profession, industry);
        });
        attendees.sort((a, b) => b.score.compareTo(a.score));

        return attendees;
      } else {
        throw Exception('Failed to load users: ${response.statusMessage}');
      }
      // QuerySnapshot requestSnapshot = await _firestore
      //     .collection('connection_requests')
      //     .where(Filter.or(Filter('received', isEqualTo: currentUserId),
      //         Filter('sent', isEqualTo: currentUserId)))
      //     .get();
      //
      // List<Map<String, dynamic>> requestDocs = requestSnapshot.docs
      //     .map((doc) => doc.data() as Map<String, dynamic>)
      //     .toList();
      //
      // List<ConnectionRequestModel> requests =
      //     requestDocs.map((e) => ConnectionRequestModel.fromJson(e)).toList();
      //
      // QuerySnapshot attendeesSnapshot = await _firestore
      //     .collection('attandees')
      //     .where('isSpeaker', isEqualTo: false)
      //     .get();
      //
      // List<AppUser> attendees =
      //     await Future.wait(attendeesSnapshot.docs.map((doc) async {
      //   final aid = (doc.data() as Map<String, dynamic>)['userId'];
      //   Map<String, dynamic>? attendeeDoc =
      //       await AuthNetworking().getUserDocument(aid);
      //   AppUser attendee = AppUser.fromJson(attendeeDoc!);
      //   attendee.id = aid;
      //   return attendee;
      // }).toList());
      // attendees.removeWhere((x) => x.id == currentUserId);
      //
      // return processRequestsAndAttendees(requests, attendees, currentUserId);
    } catch (error) {
      print("Error loading users: $error");
      throw error;
    }
  }

  int calculateUserScore(AppUser user, String? profession, String? industry) {
    int score = 0;
    if (user.userType == 'Industry Person') {
      if (user.position?.toLowerCase() == profession?.toLowerCase()) score++;
      if (user.company?.toLowerCase() == industry?.toLowerCase()) score++;
    } else if (user.userType == 'Student') {
      if (user.instituteName?.toLowerCase() == industry?.toLowerCase()) score++;
    }
    return score;
  }

  bool isValidConferenceId(String conferenceId) {
    return conferenceId.length == 24 &&
        RegExp(r'^[a-fA-F0-9]{24}$').hasMatch(conferenceId);
  }

  // List<AppUser> processRequestsAndAttendees(
  //     List<ConnectionRequestModel> requests,
  //     List<AppUser> attendees,
  //     String currentUserId) {
  //   attendees.removeWhere((attendee) => requests.any((request) =>
  //       (request.sent == currentUserId && request.received == attendee.id ||
  //           request.received == currentUserId && request.sent == attendee.id) &&
  //       (request.status == 'accepted' || request.status == 'rejected')));
  //
  //   // Step 1: Remove requests where request.sent == currentUserId
  //   attendees.removeWhere((attendee) => requests.any((request) =>
  //       request.sent == currentUserId && request.received == attendee.id));
  //
  //   // Step 2: Move requests where request.received == currentUserId to the top of the attendees list
  //   List<AppUser> topAttendees = [];
  //   for (var request in requests) {
  //     if (request.received == currentUserId) {
  //       AppUser? user = attendees.firstWhereOrNull((x) => x.id == request.sent);
  //       if (user != null) {
  //         user.isReceivedRequest = true; // Set this property
  //         topAttendees.add(user);
  //         attendees.remove(user);
  //       }
  //     }
  //   }
  //
  //   // Add topAttendees to the beginning of the attendees list
  //   attendees.insertAll(0, topAttendees);
  //
  //   return attendees;
  // }
//   Future<void> makeConnection(String receiverId) async {
//     String senderId = _auth.currentUser?.uid ?? '';
//     print("Connecting with user ID: $receiverId");
//
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('connection_requests')
//           .where('sent', isEqualTo: receiverId)
//           .where('received', isEqualTo: senderId)
//           .where('status', isEqualTo: 'pending')
//           .get();
//
//       if (querySnapshot.docs.isNotEmpty) {
//         DocumentSnapshot requestDoc = querySnapshot.docs.first;
//
//         await _firestore
//             .collection('connection_requests')
//             .doc(requestDoc.id)
//             .update({
//           'status': 'accepted',
//           'date': Timestamp.now(),
//         });
//
//         await _firestore.collection('connections').add({
//           'accepted': senderId,
//           'sent': receiverId,
//           'date': Timestamp.now(),
//         });
//       } else {
//         await _firestore.collection('connection_requests').add({
//           'sent': senderId,
//           'lastActionPerformed': senderId,
//           'received': receiverId,
//           'status': 'pending',
//           'date': Timestamp.now(),
//         });
//       }
//
//       print("Connected with user ID: $receiverId");
//     } catch (error) {
//       print('Error connecting with user: $error');
//       throw error;
//     }
//   }
//
//   Future<void> rejectUser(String receiverId) async {
//     String senderId = _auth.currentUser?.uid ?? '';
//     print("Rejecting user ID: $receiverId");
//
//     try {
//       await _firestore.collection('connection_requests').add({
//         'sent': senderId,
//         'received': receiverId,
//         'lastActionPerformed': senderId,
//         'status': 'rejected',
//         'date': Timestamp.now(),
//       });
//
//       print("Rejected user ID: $receiverId");
//     } catch (error) {
//       print('Error rejecting user: $error');
//       throw error;
//     }
//   }
// }

// Extension method to find the first element or return null if not found
// extension FirstWhereOrNullExtension<E> on List<E> {
//   E? firstWhereOrNull(bool Function(E element) test) {
//     for (E element in this) {
//       if (test(element)) {
//         return element;
//       }
//     }
//     return null;
//   }
  Future<void> swipeAndConnectAction({required String receiverId, required bool action, required String conferenceId,}) async {
    try {
      final url =
          ApiConstants.baseUrl + '/api/snc//conference/$conferenceId/swipe';
      final token = await serviceLocator<AuthenticationProvider>().authToken();

      final response = await dioInstance.post(
        url,
        data: {
          'receiverId': receiverId,
          'action': action,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      if (response.statusCode == 200) {
        print(response.data['message']);
      } else {
        throw Exception('Failed to perform action ${response.statusMessage}');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Error: ${e.response!.data['message']}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (error) {
      throw Exception('Unexpected error: $error');
    }
  }
}
