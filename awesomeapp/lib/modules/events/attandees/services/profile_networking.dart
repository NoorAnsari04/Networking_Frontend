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
      final imageName = '${DateTime.now().millisecondsSinceEpoch}.png';
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

  Future<bool> updateProfile(String id, Map<String, dynamic> UserDetails,
      String profileImgPath) async {
    try {
      // await _firestore.collection('users').doc(id).update(UserDetails);
      // return true;
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
      String? token = serviceLocator<AuthenticationProvider>().authToken();
      final dioInstance = DioClient.getDioInstance();
      final response = await dioInstance.put(url,
          data: updatedData,
          options: dio.Options(
            headers: {
              "Authorization": "Bearer $token",
            },
          ));
      print('Update Profile Reason: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        final user = AppUser.fromJson(updatedData);
        await HiveService().saveUser(user);
        print('Profile updated successfully');
        return true;
      } else {
        print('Unexpected response: ${response.data}');
      }
    } catch (e) {
      print('Update Profile API Error: $e');
    }
    return false;
  }
}
