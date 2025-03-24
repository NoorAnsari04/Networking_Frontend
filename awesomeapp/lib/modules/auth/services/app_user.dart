
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
  String? yearsOfExperience;

  @HiveField(10)
  String? linkedInUrl;

  @HiveField(11)
  String? degreeProgram;

  @HiveField(12)
  String? yearOfGraduation;

  @HiveField(13)
  String? instituteName;

  @HiveField(14)
  String? accessToken;

  @HiveField(15)
  String? refreshToken;

  bool isReceivedRequest;

  // New fields (not saved in Hive)
  @HiveField(16)
  String? userType;

  List<String>? interests;

  int score;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.lastName,
    required this.position,
    required this.company,
    required this.description,
    required this.imageUrl,
    required this.yearsOfExperience,
    required this.linkedInUrl,
    required this.sessionsDeliver,
    this.isReceivedRequest = false,
    this.userType,
    required this.degreeProgram,
    required this.yearOfGraduation,
    required this.instituteName,
    this.interests,
    this.accessToken,
    this.refreshToken,
    this.score = 0,
  });

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    // print('Company from API: ${jsonUser['company']}');
    return AppUser(
      id: jsonUser['_id'] ?? '',
      name: jsonUser['firstName'] ?? '',
      email: jsonUser['email'] ?? '',
      lastName: jsonUser['lastName'] ?? '',
      position:jsonUser['position'] ?? jsonUser['designation'],
      company: jsonUser['company'],
      description: jsonUser['description'],
      imageUrl: jsonUser['imageUrl'],
      sessionsDeliver: jsonUser['sessionsDeliver'],
      yearsOfExperience: jsonUser['yearsOfExperience'],
      linkedInUrl: jsonUser['linkedInUrl'],
      isReceivedRequest: jsonUser['isReceivedRequest'] ?? false,
      userType: jsonUser['userType'],
      degreeProgram: jsonUser['degreeProgram'],
      yearOfGraduation: jsonUser['yearOfGraduation'],
      instituteName: jsonUser['instituteName'],
      interests: (jsonUser['interests'] as List<dynamic>?)?.cast<String>(),
      accessToken: jsonUser['accessToken'],
      refreshToken: jsonUser['refreshToken'],
      score: jsonUser['score']?? 0,
    );
  }



  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'firstName': name,
      'lastName': lastName,
      'email': email,
      'position': position,
      'designation': position,
      'company': company,
      'description': description,
      'imageUrl': imageUrl,
      'sessionsDeliver': sessionsDeliver,
      'yearsOfExperience': yearsOfExperience,
      'linkedInUrl': linkedInUrl,
      'isReceivedRequest': isReceivedRequest,
      'userType': userType,
      'degreeProgram': degreeProgram,
      'yearOfGraduation': yearOfGraduation,
      'instituteName': instituteName,
      'interests': interests,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'score':'score',
    };
  }

  String get fullName {
    final List<String> nameParts = [];
    if (name.isNotEmpty) nameParts.add(name);
    if (lastName.isNotEmpty) nameParts.add(lastName);
    return nameParts.join(' ').trim();
  }

  AppUser copyWith({
    String? id,
    String? name,
    String? lastName,
    String? email,
    String? imageUrl,
    String? company,
    String? position,
    String? sessionsDeliver,
    String? description,
    String? yearsOfExperience,
    String? linkedinUrl,
    bool? isReceivedRequest,
    String? userType,
    String? degreeProgram,
    String? yearOfGraduation,
    String? instituteName,
    List<String>? interests,
    String? accessToken,
    String? refreshToken,
    int?score,

  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      company: company ?? this.company,
      position: position ?? this.position,
      sessionsDeliver: sessionsDeliver ?? this.sessionsDeliver,
      description: description ?? this.description,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      linkedInUrl: linkedinUrl ?? this.linkedInUrl,
      isReceivedRequest: isReceivedRequest ?? this.isReceivedRequest,
      userType: userType ?? this.userType,
      degreeProgram: degreeProgram ?? this.degreeProgram,
      yearOfGraduation: yearOfGraduation ?? this.yearOfGraduation,
      instituteName: instituteName ?? this.instituteName,
      interests: interests ?? this.interests,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      score: score ?? this.score,
    );
  }
}
