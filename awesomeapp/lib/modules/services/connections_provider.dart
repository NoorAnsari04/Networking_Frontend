import 'package:flutter/material.dart';
import '../auth/services/app_user.dart';
import 'connections_networking.dart';

class ConnectionsProvider with ChangeNotifier {
  final ConnectionsNetworking _networking = ConnectionsNetworking();

  List<AppUser> _connections = [];
  bool _isLoading = false;

  List<AppUser> get connections => _connections;

  bool get isLoading => _isLoading;

  Future<void> loadConnections() async {
    _isLoading = true;
    notifyListeners();

    try {
      _connections = await _networking.loadConnections();
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      print("Error loading connections: $error");
      _isLoading = false;
      notifyListeners();
    }
  }
}
