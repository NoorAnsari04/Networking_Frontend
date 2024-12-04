import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/events/speakers/services/speaker_networking.dart';

import 'meeting_request_model.dart';

class SpeakerProvider with ChangeNotifier {
  final _speakerNetworking = SpeakerNetworking();

  List<AppUser> _speakers = [];
  List<Map<String, dynamic>> _meetingRequests = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get meetingRequests => _meetingRequests;

  List<AppUser> get speakers => _speakers;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool get isLoading => _isLoading;

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<void> fetchSpeakers() async {
    _isLoading = true;
    notifyListeners();

    _speakers = await _speakerNetworking.fetchSpeakers();
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> isCurrentUserSpeaker() async {
    final currentUserId = _auth.currentUser?.uid;
    if (currentUserId == null) return false;
    return await _speakerNetworking.isUserSpeaker(currentUserId);
  }

  Future<void> fetchMeetingRequests() async {
    _isLoading = true;
    notifyListeners();

    _meetingRequests = await _speakerNetworking.fetchMeetingRequests();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> createMeetingRequest(MeetingRequest request) async {
    var res = await _speakerNetworking.createMeetingRequest(request);
    notifyListeners();
    return res;
  }

  Future<String> getRequestStatus(String receiverId) async {
    var res = await _speakerNetworking.getRequestStatus(receiverId);
    return res;
  }

  Future<void> acceptMeetingRequest(String requestId, String senderId) async {
    final receiverId = _auth.currentUser?.uid ?? '';
    await _speakerNetworking.acceptMeetingRequest(
        requestId, senderId, receiverId);
    _meetingRequests
        .removeWhere((request) => request['request']['id'] == requestId);
    notifyListeners();
  }

  Future<void> rejectMeetingRequest(String requestId) async {
    await _speakerNetworking.rejectMeetingRequest(requestId);
    _meetingRequests
        .removeWhere((request) => request['request']['id'] == requestId);
    notifyListeners();
  }

  List<AppUser> filterSpeakers(String query) {
    if (query.isEmpty) {
      return _speakers;
    } else {
      final lowerCaseQuery = query.toLowerCase();
      return _speakers.where((speaker) {
        final name = speaker.name.toLowerCase();
        return name.contains(lowerCaseQuery);
      }).toList();
    }
  }
}
