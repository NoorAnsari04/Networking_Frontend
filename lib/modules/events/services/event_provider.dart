import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/events/services/event_networking.dart';
import 'event_model.dart';

class EventProvider with ChangeNotifier {
  List<EventModel> _events = [];
  bool _isLoading = false;

  List<EventModel> get events => _events;

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
}
