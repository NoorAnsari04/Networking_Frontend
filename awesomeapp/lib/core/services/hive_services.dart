import 'package:hive/hive.dart';

import '../../modules/auth/services/app_user.dart';

class HiveService {
  static const String userBoxName = 'userBox';
  static const String tokenBoxName = 'tokenBox';
  static const String userKey = 'user';
  static const String accessTokenKey = 'accessToken';
  static const String refreshTokenKey = 'refreshToken';

  static Future<void> init() async {
    Hive.registerAdapter(AppUserAdapter());
    await Hive.openBox<AppUser>(userBoxName);
    await Hive.openBox<String>(tokenBoxName);
  }

  Box<AppUser> get _userBox => Hive.box<AppUser>(userBoxName);

  Box<String> get _tokenBox => Hive.box<String>(tokenBoxName);

  // void saveUser(AppUser user) {
  //   _userBox.put(userKey, user);
  //   saveAccessToken(user.accessToken ?? '');
  // }
  bool saveUser(AppUser user) {
    try {
      _userBox.put(userKey, user);
      final x = _userBox.get(userKey);
      // saveAccessToken(user.accessToken ?? '');
      return true; // Indicate success
    } catch (e) {
      print('Error saving user: $e');
      return false; // Indicate failure
    }
  }

  AppUser? getUser() {
    final x = _userBox.get(userKey);
    return x;
  }

  // void deleteUser() {
  //   _userBox.delete(userKey);
  // }
  Future<void> deleteUser() async {
    final userBox = await Hive.openBox<AppUser>(HiveService.userBoxName);
    await userBox.delete(HiveService.userKey);

    final tokenBox = await Hive.openBox(HiveService.tokenBoxName);
    await tokenBox.delete(HiveService.accessTokenKey);
    await tokenBox.delete(HiveService.refreshTokenKey);
  }

  // Future<void> saveAccessToken(String token) async {
  //   await _tokenBox.put(accessTokenKey, token);
  // }

  // Future<void> saveRefreshToken(String token) async {
  //   await _tokenBox.put(refreshTokenKey, token);
  // }

  // String? getAccessToken(){
  //   return _tokenBox.get(accessTokenKey);
  // }
  //
  // String? getRefreshToken(){
  //   return _tokenBox.get(refreshTokenKey);
  // }

  Future<void> deleteTokens() async {
    await _tokenBox.delete(accessTokenKey);
    await _tokenBox.delete(refreshTokenKey);
  }
}
