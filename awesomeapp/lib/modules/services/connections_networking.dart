import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_test_app_flavors/core/constants/api_constants.dart';
import 'package:my_test_app_flavors/core/serviceLocator.dart';
import 'package:my_test_app_flavors/core/services/hive_services.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';
import '../../core/constants/dio_client.dart';
import '../auth/services/app_user.dart';
import '../auth/services/auth_networking.dart';

class ConnectionsNetworking {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Future<List<AppUser>> loadConnections() async {
  //   final url = ApiConstants.baseUrl + ApiConstants.getConnections;
  //   try {
  //     // String currentUserId = _auth.currentUser?.uid ?? '';
  //     //
  //     // QuerySnapshot connectionsSnapshot = await _firestore
  //     //     .collection('connections')
  //     //     .where(Filter.or(Filter('accepted', isEqualTo: currentUserId),
  //     //         Filter('sent', isEqualTo: currentUserId)))
  //     //     .get();
  //     //
  //     // List<String> connectedUserIds = connectionsSnapshot.docs.map((doc) {
  //     //   Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //     //   return data['accepted'] == currentUserId
  //     //       ? data['sent'] as String
  //     //       : data['accepted'] as String;
  //     // }).toList()
  //     String? token = serviceLocator<AuthenticationProvider>().authToken();
  //     final dioInstance = DioClient.getDioInstance();
  //     print(token);
  //     final currentUserId = _auth.currentUser?.uid ?? '';
  //     print("Current user ID: $currentUserId");
  //
  //     final response = await dioInstance.get(url,
  //         options: Options(headers: {
  //           "Authorization": "Bearer $token",
  //         }));
  //
  //     if (response.statusCode == 200 && response.data != null) {
  //       final Map<String, dynamic> responseData = response.data;
  //       if (responseData['success'] == true) {
  //         final List<dynamic> connections = responseData['data']['connections'];
  //         print("Connections: $connections");
  //
  //         // List<String> connectedUserIds = connections.map((connection) {
  //         //   return connection['sender'] == currentUserId
  //         //       ? connection['receiver'] as String
  //         //       : connection['sender'] as String;
  //         // }).toList();
  //
  //         // print("Connected User IDs: $connectedUserIds");
  //         //
  //         // List<AppUser> connectionsList = await Future.wait(
  //         //   connectedUserIds.map((userId) async {
  //         //     Map<String, dynamic>? userDoc =
  //         //         await AuthNetworking().getUserDocument(userId);
  //         //     if (userDoc == null) {
  //         //       throw Exception("User document not found for Id: $userId");
  //         //     }
  //         //     AppUser user = AppUser.fromJson(userDoc);
  //         //     user.id = userId;
  //         //     return user;
  //         //   }),
  //         // );
  //         List<AppUser> connectionsList = [];
  //         for (var connection in connections) {
  //           if (connection['sender']['_id'] == currentUserId) {
  //             final receiverId = connection['receiver'];
  //             Map<String, dynamic>? receiverDoc =
  //                 await AuthNetworking().getUserDocument(receiverId);
  //             if (receiverDoc != null) {
  //               AppUser receiverUser = AppUser.fromJson(receiverDoc);
  //               receiverUser.id = receiverId;
  //               connectionsList.add(receiverUser);
  //             }
  //           } else if (connection['receiver'] == currentUserId) {
  //             final sender = connection['sender'];
  //             AppUser senderUser = AppUser.fromJson(sender);
  //             senderUser.id = sender['_id'];
  //             connectionsList.add(senderUser);
  //           }
  //         }
  //
  //         print("Connections List: $connectionsList");
  //         return connectionsList;
  //       } else {
  //         throw Exception(
  //             "Failed to load connections: ${responseData['message']}");
  //       }
  //     } else {
  //       throw Exception("Failed to load connections: ${response.statusCode}");
  //     }
  //   } catch (error) {
  //     print("Error loading connections: $error");
  //     throw Exception('Failed to load connections: $error');
  //   }
  // }
  Future<List<AppUser>> loadConnections() async {
    try {
      final url = ApiConstants.baseUrl + ApiConstants.getConnections;
      final dioInstance = DioClient.getDioInstance();
      final appUser = await HiveService().getUser();
      final currentUserId = appUser?.id ?? '';
      print("currentUserId: $currentUserId");
      final token = await serviceLocator<AuthenticationProvider>().authToken();
      print("Token: $token");


      // Make the API call
      final response = await dioInstance.get(
        url,
        options: Options(headers: {
          "Authorization":
              "Bearer $token",
        }),
      );
      print("API response: ${response.data}");
      // Check if the API call was successful
      if (response.statusCode != 200) {
        throw Exception("Failed to load connections: ${response.statusCode}");
      }
      // Parse the response data
      final Map<String, dynamic> responseData = response.data;

      // Check if the API returned any connections
      if (!responseData['success']) {
        print("DEBUG: API returned success=false");
        return [];
      }

      if (responseData['data'] == null ||
          responseData['data']['connections'] == null ||
          (responseData['data']['connections'] as List).isEmpty) {
        print("DEBUG: No connections found in API response");
        return [];
      }

      // Get the list of connections
      final List<dynamic> connections = responseData['data']['connections'];
      print("DEBUG: Found ${connections.length} connections in API response");

      List<AppUser> connectionsList = [];

      // Loop through each connection
      for (var connection in connections) {
        if (connection is Map<String, dynamic>) {
          final senderRaw = connection['sender'];
          final receiverRaw = connection['receiver'];

          if (senderRaw == null || receiverRaw == null) {
            print("DEBUG: sender or receiver is null, skipping...");
            continue;
          }
          final Map<String, dynamic> senderDetails =
              connection['sender'] as Map<String, dynamic>;
          final Map<String, dynamic> receiverDetails = connection['receiver'];
          final String senderId = senderDetails['_id'] ?? '';
          final String receiverId = receiverDetails['_id'] ?? '';
          // print(
          //     "DEBUG: Connection - senderId: $senderId, receiverId: $receiverId");
          // print("DEBUG: Comparing with currentUserId: $currentUserId");

          if (senderId == currentUserId) {
            // Current user is the sender, add receiver
            // print(
            //     "DEBUG: Current user is the sender, fetching receiver details");
            // Map<String, dynamic>? receiverDoc =
            //     await AuthNetworking().getUserDocument(receiverId);
            AppUser receiverUser = AppUser.fromJson(receiverDetails);
            receiverUser.id = receiverId;
            connectionsList.add(receiverUser);
            // if (receiverDoc != null) {
            //   AppUser receiverUser = AppUser.fromJson(receiverDoc);
            //   receiverUser.id = receiverId;
            //   connectionsList.add(receiverUser);
            //   print("DEBUG: Added receiver to connections list");
            // } else {
            //   print("DEBUG: Receiver document is null for ID: $receiverId");
            // }
          } else if (receiverId == currentUserId) {
            // Current user is the receiver, add sender
            // print("DEBUG: Current user is the receiver, adding sender");
            AppUser senderUser = AppUser.fromJson(senderDetails);
            senderUser.id = senderId;
            connectionsList.add(senderUser);
            // print("DEBUG: Added sender to connections list");
          }
            // else {
          //   print(
          //       "DEBUG: Current user ($currentUserId) is neither sender ($senderId) nor receiver ($receiverId)");
          // }
        }
      }

      print("DEBUG: Final connections list size: ${connectionsList.length}");
      return connectionsList;
    } catch (error) {
      print("DEBUG: Error loading connections: $error");
      throw error;
    }
  }
}
