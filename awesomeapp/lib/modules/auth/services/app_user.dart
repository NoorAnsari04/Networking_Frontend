
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
  String? yearOfExperience;

  @HiveField(10)
  String? linkedinUrl;

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
  String? userType;

  List<String>? interests;

  AppUser(
      {required this.id,
      required this.name,
      required this.email,
      required this.lastName,
      required this.position,
      required this.company,
      required this.description,
      required this.imageUrl,
      required this.yearOfExperience,
      required this.linkedinUrl,
      required this.sessionsDeliver,
      this.isReceivedRequest = false,
      this.userType,
      required this.degreeProgram,
      required this.yearOfGraduation,
      required this.instituteName,
      this.interests,
      this.accessToken,
      this.refreshToken});

//   factory AppUser.fromJson(Map<String, dynamic> json) {
//     log(jsonEncode(json));
//   final user = json['user'] as Map<String, dynamic>? ?? {};
//   return AppUser(
//     id: user['_id'] ?? '',
//     name: user['firstName'] ?? 'unknown',  // Map firstName correctly
//     email: user['email'] ?? '',
//     lastName: user['lastName'] ?? 'unknown', // Map lastName correctly
//     position: user['designation'],
//     company: user['company'],
//     description: user['description'],
//     imageUrl: user['imageUrl'],
//     sessionsDeliver: user['sessionsDeliver'],
//     experience: user['experience'],
//     linkedinUrl: user['linkedinUrl'],
//     isReceivedRequest: user['isReceivedRequest'] ?? false,
//     isStudent: user['isStudent'] ?? false,
//     degreeProgram: user['degreeProgram'],
//     yearOfGraduation: user['yearOfGraduation'],
//     instituteName: user['instituteName'],
//     interests: (user['interests'] as List<dynamic>?)?.cast<String>(),
//     accessToken: json['accessToken'],
//     refreshToken: json['refreshToken'],
//   );
// }

  

  factory AppUser.fromJson(Map<String, dynamic> jsonUser) {
    // log(jsonEncode(json));
    // final jsonUser = json;
    // var jsonUser=json["user"];
    return AppUser(
      id: jsonUser['_id'] ?? '',
      name: jsonUser['firstName'] ?? '',
      email: jsonUser['email'] ?? '',
      lastName: jsonUser['lastName'] ?? '',
      position: jsonUser['designation'],
      company: jsonUser['company'],
      description: jsonUser['description'],
      imageUrl: jsonUser['imageUrl'],
      sessionsDeliver: jsonUser['sessionsDeliver'],
      yearOfExperience: jsonUser['yearOfExperience'],
      linkedinUrl: jsonUser['linkedInUrl'],
      isReceivedRequest: jsonUser['isReceivedRequest'] ?? false,
      userType: jsonUser['userType'] ,
      degreeProgram: jsonUser['degreeProgram'],
      yearOfGraduation: jsonUser['yearOfGraduation'],
      instituteName: jsonUser['instituteName'],
      interests: (jsonUser['interests'] as List<dynamic>?)?.cast<String>(),
      accessToken: jsonUser['accessToken'],
      refreshToken: jsonUser['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'accessToken': accessToken,
      'linkedInUrl': linkedinUrl,
      'description': description,
      'company' : company,

    };
  }

  // String get fullName {
  //   final firstName = name.isNotEmpty ? name : '';
  //   final lastNamePart = lastName.isNotEmpty ? lastName : '';
  //   return [firstName, lastNamePart].where((part) => part.isNotEmpty).join(' ');
  // }

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
    String? experience,
    String? linkedinUrl,
    bool? isReceivedRequest,
    String? userType,
    String? degreeProgram,
    String? yearOfGraduation,
    String? instituteName,
    List<String>? interests,
    String? accessToken,
    String? refreshToken,
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
      yearOfExperience: experience ?? this.yearOfExperience,
      linkedinUrl: linkedinUrl ?? this.linkedinUrl,
      isReceivedRequest: isReceivedRequest ?? this.isReceivedRequest,
      userType: userType?? this.userType,
      degreeProgram: degreeProgram ?? this.degreeProgram,
      yearOfGraduation: yearOfGraduation ?? this.yearOfGraduation,
      instituteName: instituteName ?? this.instituteName,
      interests: interests ?? this.interests,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
