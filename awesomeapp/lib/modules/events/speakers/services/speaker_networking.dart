import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_networking.dart';

import 'meeting_request_model.dart';

class SpeakerNetworking {
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

  Future<List<AppUser>> fetchSpeakers() async {
    try {
      String currentUserId = _auth.currentUser?.uid ?? '';
      print("Fetching speakers for current user ID: $currentUserId");

      QuerySnapshot speakersSnapshot =
          await _firestore.collection('speakers').get();

      List<AppUser> speakers = [];

      for (var doc in speakersSnapshot.docs) {
        final sid = (doc.data() as Map<String, dynamic>)['userId'];
        if (sid != currentUserId) {
          Map<String, dynamic>? speakerDoc =
              await AuthNetworking().getUserDocument(sid);
          if (speakerDoc != null) {
            AppUser speaker = AppUser.fromJson(speakerDoc);
            speaker.id = sid;
            speakers.add(speaker);
          }
        }
      }

      return speakers;
    } catch (e) {
      print("Error fetching speakers: $e");
      return [];
    }
  }

  // todo make func of type List<MeetingRequest>
  Future<List<Map<String, dynamic>>> fetchMeetingRequests() async {
    try {
      String currentUserId = _auth.currentUser?.uid ?? '';

      QuerySnapshot requestsSnapshot = await _firestore
          .collection('meeting_requests')
          .where('receiverId', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'pending')
          .get();

      List<Map<String, dynamic>> requests = [];
      List<MeetingRequest> meetingRequest = [];

      for (var doc in requestsSnapshot.docs) {
        final requestData = doc.data() as Map<String, dynamic>;
        final senderId = requestData['senderId'];

        Map<String, dynamic>? senderDoc =
            await AuthNetworking().getUserDocument(senderId);
        if (senderDoc != null) {
          final data = doc.data();
          // todo parse senderDoc to AppUser
          // data // todo update data with id and 'user': senderDoc
          // meetingRequest.add(MeetingRequest.fromJson())
          requests.add({
            'request': {
              ...requestData,
              'id': doc.id,
            },
            'user': senderDoc,
          });
        }
      }

      return requests;
    } catch (error) {
      print("Error fetching meeting requests: $error");
      throw error;
    }
  }

  Future<void> acceptMeetingRequest(
      String requestId, String senderId, String receiverId) async {
    try {
      await _firestore
          .collection('meeting_requests')
          .doc(requestId)
          .update({'status': 'accepted'});

      await _firestore.collection('connections').add({
        'accepted': receiverId,
        'sent': senderId,
        'date': Timestamp.now(),
      });
    } catch (e) {
      print('Error accepting meeting request: $e');
      throw e;
    }
  }

  Future<void> rejectMeetingRequest(String requestId) async {
    try {
      await _firestore
          .collection('meeting_requests')
          .doc(requestId)
          .update({'status': 'rejected'});
    } catch (e) {
      print('Error rejecting meeting request: $e');
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
