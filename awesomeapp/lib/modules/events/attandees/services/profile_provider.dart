import 'dart:io';

import 'package:my_test_app_flavors/core/services/hive_services.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';
import 'package:my_test_app_flavors/modules/events/attandees/services/profile_networking.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class ProfileProvider with ChangeNotifier {
  final _profileNetworking = ProfileNetworking();

  bool get isLoading => _isLoading;
  bool _isLoading = false;

  Future<String> uploadImage(File image) async =>
      _profileNetworking.uploadImage(image);

  Future<bool> updateProfile(BuildContext context,
      Map<String, dynamic> userDetails, String? profileImgPath) async {
    AuthenticationProvider _authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);
    _isLoading = true;
    notifyListeners();
    try {
      final res = await _profileNetworking.updateProfile(
          _authProvider.appUser!.id, userDetails, profileImgPath ?? '');

      if (res) {
        final user = AppUser.fromJson(userDetails);
        _authProvider.updateUser(user);
        print("Profile updated successfully");
        // final newToken = await _profileNetworking.refreshToken();
        // if(newToken != null){
        //   await HiveService().saveAccessToken(newToken);
        //   _authProvider.updateToken(newToken);
        // }
      }
      return res;
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
