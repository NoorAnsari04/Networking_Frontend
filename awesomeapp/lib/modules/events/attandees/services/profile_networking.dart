import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart' as dio;
import 'package:my_test_app_flavors/core/constants/dio_client.dart';
import 'package:my_test_app_flavors/core/serviceLocator.dart';
import 'package:my_test_app_flavors/core/services/hive_services.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';
import '../../../../core/constants/api_constants.dart';

class ProfileNetworking {
  final _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> uploadImage(File image) async {
    try {
      final imageName = '${DateTime
          .now()
          .millisecondsSinceEpoch}.png';
      final firebaseStorageRef = _storage.ref().child('images/$imageName');
      final uploadTask = firebaseStorageRef.putFile(image);
      final taskSnapshot = await uploadTask;
      final imageUrl = await taskSnapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Upload Error: $e');
      throw e;
    }
  }

  Future<String?> refreshToken() async {
    final refreshToken = await HiveService().getRefreshToken();
    if (refreshToken == null) {
      print("No refresh token found");
      return null;
    }

    final dioInstance = DioClient.getDioInstance();
    final response = await dioInstance.post(
      ApiConstants.baseUrl + ApiConstants.refreshToken,
      data: {
        'refresh_token': refreshToken,
      },
    );
    if (response.statusCode == 200 && response.data["success"] == true) {
      final newToken = response.data['token'];
      await HiveService().saveAccessToken(newToken);
      return newToken;
    } else {
      print("Failed to refresh token: ${response.data}");
      return null;
    }
  }

  Future<bool> updateProfile(String id, Map<String, dynamic> UserDetails,
      String profileImgPath) async {
    try {
      // await _firestore.collection('users').doc(id).update(UserDetails);
      // return true;
      String? token = serviceLocator<AuthenticationProvider>().authToken();
      if (token == null) {
        print("Token is null, User is not authenticated");
        return false;
      }

      print("Retrieved token: $token");

      final Map<String, dynamic> updatedData = {
        if (UserDetails['name'] != null) 'name': UserDetails['name'],
        if (UserDetails['company'] != null) 'company': UserDetails['company'],
        if (UserDetails['position'] != null)
          'position': UserDetails['position'],
        if (UserDetails['email'] != null) 'email': UserDetails['email'],
        if (UserDetails['description'] != null)
          'description': UserDetails['description'],
        if (UserDetails['linkedInUrl'] != null)
          'linkedInUrl': UserDetails['linkedInUrl'],
      };

      updatedData['profileImg'] = profileImgPath;

      final url = ApiConstants.baseUrl + ApiConstants.editProfile;
      final dioInstance = DioClient.getDioInstance();
      final response = await dioInstance.put(url,
          data: updatedData,
          options: dio.Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ));

      if (response.statusCode == 200 && response.data['success'] == true) {
        print("Profile updated successfully");
        final Map<String, dynamic> userData = response.data ['data']['user'] ?? {};
        userData['accessToken'] = token ;
        // final String? newToken = response.data['data']['accessToken'];
        print("Token retrieved: $token");
        final authProvider = serviceLocator<AuthenticationProvider>();
        authProvider.updateUser(AppUser.fromJson(userData));
        if(userData.isNotEmpty){
          final appUser = AppUser.fromJson(userData);
          print("Saving user: ${jsonEncode(appUser.toJson())}");
          await HiveService().saveUser(appUser);
          await HiveService().saveAccessToken(token);
          final savedUser = await HiveService().getUser();
          print("Saved user from Hive: ${jsonEncode(savedUser?.toJson())}");
        } else {
          print("User data is missing or empty");
        }
        return true;
      } else {
        print("Failed to update profile: ${response.data['message']}");
        return false;
      }
    } catch (e) {
      print("Error updating profile: $e");
      return false;
    }
  }
}