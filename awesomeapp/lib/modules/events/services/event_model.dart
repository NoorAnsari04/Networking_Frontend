import 'package:intl/intl.dart';

class EventModel {
  String posterUrl;
  String startDate;
  String endDate;
  String venue;
  String title;
  String time;

  EventModel({
    required this.posterUrl,
    required this.startDate,
    required this.venue,
    required this.title,
    required this.endDate,
    required this.time,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      posterUrl: json['posterUrl'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      venue: json['venue'] ?? '',
      title: json['title'] ?? '',
      time: json['time'] ?? '',
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
