import 'package:flutter/material.dart';
import '../../../events/ticket/services/ticket_networking.dart';

class TicketProvider with ChangeNotifier{
  final TicketNetworking _ticketNetworking = TicketNetworking();
  bool _isLoading = false;
  Map<String, dynamic>? _ticketDetails;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get ticketDetails => _ticketDetails;
  String? get errorMessage => _errorMessage;

  Future<void> fetchTicketDetails(String eventId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _ticketDetails = await _ticketNetworking.getTicketDetails(eventId);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}