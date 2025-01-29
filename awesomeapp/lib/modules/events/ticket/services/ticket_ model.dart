import 'package:intl/intl.dart';
import '../../../events/services/event_model.dart';

class TicketModel {
  String ticketId;
  String qrCode;
  String venue;
  String time;
  String startDate;
  String endDate;

  TicketModel({
    required this.ticketId,
    required this.qrCode,
    required this.venue,
    required this.time,
    required this.startDate,
    required this.endDate,
  });

  factory TicketModel.fromEvent(
      EventModel event, String ticketId, String qrCode) {
    return TicketModel(
        ticketId: ticketId,
        qrCode: qrCode,
        venue: event.venue,
        time: event.time,
        startDate: event.startDate,
        endDate: event.endDate);
  }

  //  static DateTime parseDate(String dateStr) {
  //   try {
  //     String cleanedDateStr = dateStr.replaceAll(RegExp(r'(st|nd|rd|th)'), '');
  //     return DateFormat('d - MMMM', 'en_US').parse(cleanedDateStr);
  //   } catch (e) {
  //     print('Error parsing date: $e');
  //     return DateTime.now();
  //   }
  // }
}
