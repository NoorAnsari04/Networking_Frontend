import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/events/swipe%20and%20connect/components/dropdown.dart';
import 'package:my_test_app_flavors/modules/events/swipe%20and%20connect/services/swipe_connect_networking.dart';

import '../../../../core/services/hive_services.dart';

class SwipeAndConnectProvider with ChangeNotifier {
  final SwipeAndConnectNetworking _networking = SwipeAndConnectNetworking();
  final hiveService = HiveService();

  List<AppUser> _rejectedUsers = [];
  List<AppUser> _acceptedUsers = [];
  int _currentIndex = 0;
  List<AppUser> _attendees = [];
  bool _isLoading = false;
  bool _disposed = false;
  Map<String, String> _interestsMap = {};
  List<DropdownOptions> _interests=[];

  bool _isLoadingInterests = false;

  List<DropdownOptions> get interests=>_interests;

  Map<String, String> get interestsMap => _interestsMap;

  bool get isLoadingInterests => _isLoadingInterests;

  List<AppUser> get rejectedUsers => _rejectedUsers;

  List<AppUser> get acceptedUsers => _acceptedUsers;

  List<AppUser> get attendees => _attendees;

  int get currentIndex => _currentIndex;

  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> loadDropdownInterests() async {
    if (_interests.isNotEmpty) return;
    _isLoadingInterests = true;
    notifyListeners();
    try {
      _interests = await _networking.loadDropdownInterests();
    } catch (e) {
      print('Error loading interests: $e');
      _interests = [];
    } finally {
      _isLoadingInterests = false;
      notifyListeners();
    }
  }


  Future<void> loadInterests() async {
    if (_interestsMap.isNotEmpty) return;
    _isLoadingInterests = true;
    notifyListeners();
    try {
      _interestsMap = await _networking.loadInterests();
    } catch (e) {
      print('Error loading interests: $e');
      _interestsMap = {};
    } finally {
      _isLoadingInterests = false;
      notifyListeners();
    }
  }

  Future<void> loadUsers(String conferenceId, {String? userType, String? profession, String? industry}) async {
    _isLoading = true;
    notifyListeners();
    try {
      print("Loading users for conference: $conferenceId");
      List<AppUser> allAttendees = await _networking.loadUsers(conferenceId,userType: userType,
          profession: profession, industry: industry);
      print("Loaded ${_attendees.length} users from API");

      _attendees = allAttendees.where((user) {
        return !_rejectedUsers.any((rejected) => rejected.id == user.id) &&
            !_acceptedUsers.any((accepted) => accepted.id == user.id);
      }).toList();

      // Map any interest IDs that don't have names yet
      if (_interestsMap.isNotEmpty) {
        for (var user in _attendees) {
          if (user.interests != null && user.interests!.isNotEmpty) {
            if (user.interestNames == null || user.interestNames!.isEmpty) {
              print("Mapping interests for user: ${user.fullName}");
              user.interestNames = user.interests!
                  .map((id) => _interestsMap[id] ?? 'Interest: $id')
                  .toList();
              print("Mapped interests: ${user.interestNames}");
            }
          } else {
            user.interestNames = [];
          }
        }
      }
    } catch (error) {
      print("Error loading users: $error");
      _attendees = [];
    }
    _isLoading = false;
    if (!_disposed) {
      notifyListeners();
    }
  }

  // Future<void> loadUsers(String conferenceId,
  //     {String? designation, String? interests}) async {
  //   _isLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     print("Loading users for conference: $conferenceId");
  //
  //     // Convert industry name to ID
  //     String? interestId;
  //     if (interests != null && _interestsMap.isNotEmpty) {
  //       final reverseMap = Map.fromEntries(
  //           _interestsMap.entries.map((e) => MapEntry(e.value, e.key)));
  //       interestId = reverseMap[interests];
  //       print("Converted industry '$interests' to ID: $interestId");
  //     }
  //
  //     List<AppUser> allAttendees = await _networking.loadUsers(
  //       conferenceId,
  //       designation: designation,
  //       interests: interestId, // 👈 pass ObjectId now
  //     );
  //
  //     print("Loaded ${allAttendees.length} users from API");
  //
  //     _attendees = allAttendees.where((user) {
  //       return !_rejectedUsers.any((r) => r.id == user.id) &&
  //           !_acceptedUsers.any((a) => a.id == user.id);
  //     }).toList();
  //
  //     // Map interest IDs to names
  //     for (var user in _attendees) {
  //       user.interestNames = user.interests
  //               ?.map((id) => _interestsMap[id] ?? 'Interest: $id')
  //               .toList() ??
  //           [];
  //     }
  //   } catch (error) {
  //     print("Error loading users: $error");
  //     _attendees = [];
  //   }
  //
  //   _isLoading = false;
  //   if (!_disposed) notifyListeners();
  // }

  // Future<void> makeConnection(String receiverId) async {
  //   await _networking.makeConnection(receiverId);
  //   _attendees.removeAt(_currentIndex);
  //   if (_currentIndex >= _attendees.length) {
  //     _currentIndex = 0;
  //   }
  //   notifyListeners();
  // }
  //
  // Future<void> rejectUser(String receiverId) async {
  //   await _networking.rejectUser(receiverId);
  //   _rejectedUsers.add(_attendees[_currentIndex]);
  //   _attendees.removeAt(_currentIndex);
  //   if (_currentIndex >= _attendees.length) {
  //     _currentIndex = 0;
  //   }
  //   notifyListeners();
  // }
  Future<void> swipeAndConnectAction({required String receiverId, required bool action, required String conferenceId,}) async {
    try {
      await _networking.swipeAndConnectAction(
          receiverId: receiverId, action: action, conferenceId: conferenceId);
      final currentUser = _attendees[_currentIndex];
      if (action) {
        _acceptedUsers.add(currentUser);
      } else {
        _rejectedUsers.add(currentUser);
      }
      _attendees.removeAt(_currentIndex);
      notifyListeners();
    } catch (error) {
      print("Error performing swipe action: $error");
      throw error;
    }
  }

  void clear() {
    _rejectedUsers = [];
    _acceptedUsers = [];
    _currentIndex = 0;
    _attendees = [];
    _isLoading = false;
    _interestsMap = {};
    _isLoadingInterests = false;
    notifyListeners();
  }
}
