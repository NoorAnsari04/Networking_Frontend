import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/events/services/event_networking.dart';
import 'event_model.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> _events = [];
  EventModel? _selectedEvent;
  bool _isLoading = false;

  List<EventModel> get events => _events;
  EventModel? get selectedEvent => _selectedEvent;

  bool get isLoading => _isLoading;

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await EventNetworking.fetchEvents();
      if (res.isNotEmpty) {
        _events = List.from(res);
        _events.sort((a, b) => EventModel.parseDate(a.startDate)
            .compareTo(EventModel.parseDate(b.startDate)));
      }
    } catch (e) {
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<EventModel?> fetchEventById(eventId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final res = await EventNetworking.fetchEventById(eventId);
      // _selectedEvent = res;
      return res;
    } catch (e) {
      print("Error fetching event by ID: $e");

    } finally{
      _isLoading = false;
      notifyListeners();
    }
// notifyListeners();
    return null;
  }

  void clearSelectedEvent(){
    _selectedEvent = null;
    notifyListeners();
  }
}
