class ApiConstants {
  static const String baseUrl = 'http://192.168.18.126:3000';
  static const String login = '/api/auth/login/';
  static const String signUp = '/api/auth/signup/';
  static const String userDetails = '/api/user/update';
  static const String refreshToken = '/api/auth/refresh';
  static const String allEvents = '/api/conference/all/';
  static const String eventSpeakers = '/api/conference/all/';
  static const String eventById = '/api/conference/:id';
  static const String fetchTicket = '/api/ticket/:conferenceId';
  static const String editProfile = '/api/user/edit';
  static const String socialSignup = '/api/auth/googleSignup';

  static const int connectTimeout = 5000;
  static const int receiveTimeout = 3000;
}