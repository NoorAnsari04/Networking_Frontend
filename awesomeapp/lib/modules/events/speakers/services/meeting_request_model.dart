class MeetingRequest {
  final String senderId;
  final String receiverId;
  final String status;
  final DateTime timestamp;
  final String? meetingTitle;
  final String? attendeeName;
  final String? company;
  final String? position;
  final String? university;
  final String? degreeProgram;
  final String? email;

  MeetingRequest({
    required this.senderId,
    required this.receiverId,
    this.status = 'pending',
    DateTime? timestamp,
    this.meetingTitle,
    this.attendeeName,
    this.company,
    this.position,
    this.university,
    this.degreeProgram,
    this.email,
  }) : this.timestamp = timestamp ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'status': status,
      'timestamp': timestamp.toIso8601String(),
      if (meetingTitle != null) 'meetingTitle': meetingTitle,
      if (attendeeName != null) 'attendeeName': attendeeName,
      if (company != null) 'company': company,
      if (position != null) 'position': position,
      if (university != null) 'university': university,
      if (degreeProgram != null) 'degreeProgram': degreeProgram,
      if (email != null) 'email': email,
    };
  }

  factory MeetingRequest.fromJson(Map<String, dynamic> json) {
    return MeetingRequest(
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      status: json['status'],
      timestamp: DateTime.parse(json['timestamp']),
      meetingTitle: json['meetingTitle'],
      attendeeName: json['attendeeName'],
      company: json['company'],
      position: json['position'],
      university: json['university'],
      degreeProgram: json['degreeProgram'],
      email: json['email'],
    );
  }
}
