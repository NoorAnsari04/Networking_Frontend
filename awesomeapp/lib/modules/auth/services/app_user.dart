import 'package:hive/hive.dart';

part 'app_user.g.dart';

@HiveType(typeId: 0)
class AppUser {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String email;

  @HiveField(4)
  String? imageUrl;

  @HiveField(5)
  String? company;

  @HiveField(6)
  String? position;

  @HiveField(7)
  String? sessionsDeliver;

  @HiveField(8)
  String? description;

  @HiveField(9)
  String? experience;

  @HiveField(10)
  String? linkedinUrl;

  @HiveField(11)
  String? degreeProgram;

  @HiveField(12)
  String? yearOfGraduation;

  @HiveField(13)
  String? instituteName;

  bool isReceivedRequest;

  // New fields (not saved in Hive)
  bool? isStudent;

  List<String>? interests;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.lastName,
    required this.position,
    required this.company,
    required this.description,
    required this.imageUrl,
    required this.experience,
    required this.linkedinUrl,
    required this.sessionsDeliver,
    this.isReceivedRequest = false,
    this.isStudent,
    required this.degreeProgram,
    required this.yearOfGraduation,
    required this.instituteName,
    this.interests,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      lastName: json['lastName'] ?? '',
      position: json['position'],
      company: json['company'],
      description: json['description'],
      imageUrl: json['imageUrl'],
      sessionsDeliver: json['sessionsDeliver'],
      experience: json['experience'],
      linkedinUrl: json['linkedinUrl'],
      isReceivedRequest: json['isReceivedRequest'] ?? false,
      isStudent: json['isStudent'] ?? false,
      degreeProgram: json['degreeProgram'],
      yearOfGraduation: json['yearOfGraduation'],
      instituteName: json['instituteName'],
      interests: (json['interests'] as List<dynamic>?)?.cast<String>(),
    );
  }

  String get fullName => name + ' $lastName';
}
