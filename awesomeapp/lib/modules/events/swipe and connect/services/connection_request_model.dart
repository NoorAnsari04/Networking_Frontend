import 'package:cloud_firestore/cloud_firestore.dart';

class ConnectionRequestModel {
  Timestamp date;
  String received, sent, lastActionPerformed;
  String status;

  ConnectionRequestModel({
    required this.date,
    required this.received,
    required this.sent,
    required this.status,
    required this.lastActionPerformed,
  });

  factory ConnectionRequestModel.fromJson(Map<String, dynamic> json) {
    return ConnectionRequestModel(
      date: json['date'],
      sent: json['sent'],
      status: json['status'],
      received: json['received'],
      lastActionPerformed: json['lastActionPerformed'],
    );
  }
}
