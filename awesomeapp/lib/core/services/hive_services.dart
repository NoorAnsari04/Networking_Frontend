import 'package:hive/hive.dart';

import '../../modules/auth/services/app_user.dart';

class HiveService {
  static const String userBoxName = 'userBox';
  static const String userKey = 'user';

  static Future<void> init() async {
    Hive.registerAdapter(AppUserAdapter());
    await Hive.openBox<AppUser>(userBoxName);
  }

  Box<AppUser> get _userBox => Hive.box<AppUser>(userBoxName);

  void saveUser(AppUser user) {
    _userBox.put(userKey, user);
  }

  AppUser? getUser() {
    return _userBox.get(userKey);
  }

  void deleteUser() {
    _userBox.delete(userKey);
  }
}
