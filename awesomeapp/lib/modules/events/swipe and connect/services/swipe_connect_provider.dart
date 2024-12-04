import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/events/swipe%20and%20connect/services/swipe_connect_networking.dart';

class SwipeAndConnectProvider with ChangeNotifier {
  final SwipeAndConnectNetworking _networking = SwipeAndConnectNetworking();

  List<AppUser> _rejectedUsers = [];
  int _currentIndex = 0;
  List<AppUser> _attendees = [];
  bool _isLoading = false;
  bool _disposed = false;

  List<AppUser> get rejectedUsers => _rejectedUsers;

  List<AppUser> get attendees => _attendees;

  int get currentIndex => _currentIndex;

  bool get isLoading => _isLoading;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

  Future<void> loadUsers() async {
    _isLoading = true;
    notifyListeners();

    _attendees = await _networking.loadUsers();

    _isLoading = false;
    if (!_disposed) {
      notifyListeners();
    }
  }

  Future<void> makeConnection(String receiverId) async {
    await _networking.makeConnection(receiverId);
    _attendees.removeAt(_currentIndex);
    if (_currentIndex >= _attendees.length) {
      _currentIndex = 0;
    }
    notifyListeners();
  }

  Future<void> rejectUser(String receiverId) async {
    await _networking.rejectUser(receiverId);
    _rejectedUsers.add(_attendees[_currentIndex]);
    _attendees.removeAt(_currentIndex);
    if (_currentIndex >= _attendees.length) {
      _currentIndex = 0;
    }
    notifyListeners();
  }
}
