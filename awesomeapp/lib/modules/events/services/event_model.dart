import 'package:intl/intl.dart';

class EventModel {
  String eventId;
  String posterUrl;
  String startDate;
  String endDate;
  String venue;
  String title;
  String time;

  EventModel({
    required this.eventId,
    required this.title,
    required this.time,
    required this.venue,
    required this.endDate,
    required this.posterUrl,
    required this.startDate,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    
    return EventModel(
      eventId: json['_id'] ?? '',
      title: json['title'] ?? '',
      time: json['time'] ?? '',
      venue: json['venue'] ?? '',
      endDate: json['endDate'] ?? '',
      posterUrl: json['posterUrl'] ?? '',
      startDate: json['startDate'] ?? '',
    );
  }

  static DateTime parseDate(String dateStr) {
    try {
      String cleanedDateStr = dateStr.replaceAll(RegExp(r'(st|nd|rd|th)'), '');
      return DateFormat('d - MMMM', 'en_US').parse(cleanedDateStr);
    } catch (e) {
      print('Error parsing date: $e');
      return DateTime.now();
    }
  }

  static String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 17) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }
}
