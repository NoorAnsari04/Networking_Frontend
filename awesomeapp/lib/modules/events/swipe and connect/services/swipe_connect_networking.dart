import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_networking.dart';
import 'connection_request_model.dart';

class SwipeAndConnectNetworking {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<List<AppUser>> loadUsers() async {
    try {
      String currentUserId = _auth.currentUser?.uid ?? '';
      print("Loading users for current user ID: $currentUserId");

      QuerySnapshot requestSnapshot = await _firestore
          .collection('connection_requests')
          .where(Filter.or(Filter('received', isEqualTo: currentUserId),
              Filter('sent', isEqualTo: currentUserId)))
          .get();

      List<Map<String, dynamic>> requestDocs = requestSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      List<ConnectionRequestModel> requests =
          requestDocs.map((e) => ConnectionRequestModel.fromJson(e)).toList();

      QuerySnapshot attendeesSnapshot = await _firestore
          .collection('attandees')
          .where('isSpeaker', isEqualTo: false)
          .get();

      List<AppUser> attendees =
          await Future.wait(attendeesSnapshot.docs.map((doc) async {
        final aid = (doc.data() as Map<String, dynamic>)['userId'];
        Map<String, dynamic>? attendeeDoc =
            await AuthNetworking().getUserDocument(aid);
        AppUser attendee = AppUser.fromJson(attendeeDoc!);
        attendee.id = aid;
        return attendee;
      }).toList());
      attendees.removeWhere((x) => x.id == currentUserId);

      return processRequestsAndAttendees(requests, attendees, currentUserId);
    } catch (error) {
      print("Error loading users: $error");
      throw error; // todo return empty list
    }
  }

  List<AppUser> processRequestsAndAttendees(
      List<ConnectionRequestModel> requests,
      List<AppUser> attendees,
      String currentUserId) {
    attendees.removeWhere((attendee) => requests.any((request) =>
        (request.sent == currentUserId && request.received == attendee.id ||
            request.received == currentUserId && request.sent == attendee.id) &&
        (request.status == 'accepted' || request.status == 'rejected')));

    // Step 1: Remove requests where request.sent == currentUserId
    attendees.removeWhere((attendee) => requests.any((request) =>
        request.sent == currentUserId && request.received == attendee.id));

    // Step 2: Move requests where request.received == currentUserId to the top of the attendees list
    List<AppUser> topAttendees = [];
    for (var request in requests) {
      if (request.received == currentUserId) {
        AppUser? user = attendees.firstWhereOrNull((x) => x.id == request.sent);
        if (user != null) {
          user.isReceivedRequest = true; // Set this property
          topAttendees.add(user);
          attendees.remove(user);
        }
      }
    }

    // Add topAttendees to the beginning of the attendees list
    attendees.insertAll(0, topAttendees);

    return attendees;
  }

  Future<void> makeConnection(String receiverId) async {
    String senderId = _auth.currentUser?.uid ?? '';
    print("Connecting with user ID: $receiverId");

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('connection_requests')
          .where('sent', isEqualTo: receiverId)
          .where('received', isEqualTo: senderId)
          .where('status', isEqualTo: 'pending')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot requestDoc = querySnapshot.docs.first;

        await _firestore
            .collection('connection_requests')
            .doc(requestDoc.id)
            .update({
          'status': 'accepted',
          'date': Timestamp.now(),
        });

        await _firestore.collection('connections').add({
          'accepted': senderId,
          'sent': receiverId,
          'date': Timestamp.now(),
        });
      } else {
        await _firestore.collection('connection_requests').add({
          'sent': senderId,
          'lastActionPerformed': senderId,
          'received': receiverId,
          'status': 'pending',
          'date': Timestamp.now(),
        });
      }

      print("Connected with user ID: $receiverId");
    } catch (error) {
      print('Error connecting with user: $error');
      throw error;
    }
  }

  Future<void> rejectUser(String receiverId) async {
    String senderId = _auth.currentUser?.uid ?? '';
    print("Rejecting user ID: $receiverId");

    try {
      await _firestore.collection('connection_requests').add({
        'sent': senderId,
        'received': receiverId,
        'lastActionPerformed': senderId,
        'status': 'rejected',
        'date': Timestamp.now(),
      });

      print("Rejected user ID: $receiverId");
    } catch (error) {
      print('Error rejecting user: $error');
      throw error;
    }
  }
}

// Extension method to find the first element or return null if not found
extension FirstWhereOrNullExtension<E> on List<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
