import 'package:flutter/material.dart';
import '../auth/services/app_user.dart';
import 'connections_networking.dart';

class ConnectionsProvider with ChangeNotifier {
  final ConnectionsNetworking _networking = ConnectionsNetworking();

  List<AppUser> _connections = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<AppUser> get connections => _connections;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  Future<void> loadConnections() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _connections = await _networking.loadConnections();
    } catch (error) {
      _errorMessage = "Failed to load connections: $error";
      print("Error loading connections: $error");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearConnections() {
    _connections.clear();
    _errorMessage = null;
    notifyListeners();
  }
}
