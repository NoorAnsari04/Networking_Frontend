import 'package:cloud_firestore/cloud_firestore.dart';
import 'event_model.dart';

class EventNetworking {
  static Future<List<EventModel>> fetchEvents() async {
    final querySnapshot =
        await FirebaseFirestore.instance.collection('conferences').get();
    List<EventModel> events = querySnapshot.docs
        .map((doc) => EventModel.fromJson(doc.data()))
        .toList();

    return events;
  }
}
