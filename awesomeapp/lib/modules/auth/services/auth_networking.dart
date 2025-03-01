import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dio/dio.dart';
import 'package:my_test_app_flavors/core/services/hive_services.dart';
import 'app_user.dart';
import '../../../core/constants/api_constants.dart'; // Relative path

class AuthNetworking {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  Dio _dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
  ));

  Future<AppUser?> signUp({
    required String email,
    required String password,
    required String firstName,
    required String lastname,
    required String confirmPassword,
  }) async {
    try {
      final response = await _dio.post(ApiConstants.signUp, data: {
        "firstName": firstName,
        "lastName": lastname,
        "email": email,
        "password": password,
        "confirmPassword": confirmPassword,
      });
      print('Signup Response: ${response.data}');

      if (response.statusCode == 200 && response.data['success'] == true) {
        // // final userCredential = await firebaseAuth
        // //     .createUserWithEmailAndPassword(email: email, password: password);
        // final success = response.data['success'] ?? false;
        // if (success) {
        //   final userData = response.data['data'];
        //   if (userData != null) {
        //     final appUser = AppUser.fromJson(userData);
        //     // appUser.accessToken = response.data['token'];
        //     HiveService().saveUser(appUser);
        //     print('Signup Successful: ${appUser.email}');
        //     return appUser;
        //   } else {
        //     print('User data is null or missing');
        //   }
        // } else {
        //   print('Signup Failed: ${response.data['message']}');
        // }
        final Map<String, dynamic> userData = {}; //response.data['data'];
        userData['accessToken'] = response.data['data']['accessToken'];
        userData['refreshToken'] = response.data['data']['refreshToken'];
        userData.addAll(response.data['data']['user']);
        if (userData.isNotEmpty) {
          final appUser = AppUser.fromJson(userData);
          await HiveService().saveUser(appUser);
          print('SignUp Successfull: ${appUser.fullName}');
          return appUser;
        } else {
          print("the user is null");
        }
      } else {
        print('Unexpectes status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Signup API Error: $e');
    }
    return null;
  }

  Future<void> createUserDocument(
      String userId, Map<String, dynamic> userData) async {
    try {
      await firestore.collection('users').doc(userId).set(userData);
    } catch (e) {
      print(e);
    }
  }

  Future<bool> isUserDocumentExist(String userId) async {
    try {
      var docSnapshot = await firestore.collection('users').doc(userId).get();
      return docSnapshot.exists;
    } catch (e) {
      print('Error checking user document: $e');
      return false;
    }
  }

  Future<AppUser?> login(String email, String password) async {
    // try {
    //   final response = await _dio.post(ApiConstants.login,
    //       data: {'email': email, 'password': password});
    //   if (response.statusCode == 200) {
    //     final userCredential = await firebaseAuth.signInWithEmailAndPassword(
    //         email: email, password: password);
    //     final userDoc = await getUserDocument(userCredential.user!.uid);
    //     if (userDoc != null) {
    //       userDoc.update('id', (value) => userCredential.user!.uid,
    //           ifAbsent: () => userCredential.user!.uid);
    //       return AppUser.fromJson(userDoc);
    //     }
    //   }
    // } catch (e) {
    //   print(e);
    // }
    // return null;
    try {
      final response = await _dio.post(ApiConstants.login,
          data: {'email': email, 'password': password});
      print('Api Response: ${response.data}');
      if (response.statusCode == 200 && response.data['success'] == true) {
        // final success = response.data['success'] ?? false;
        // if (success) {
        //   final userData = response.data['data']['user'];
        //   print(userData);
        //   final token = response.data['data']['accessToken'];
        //   if (userData != null) {
        //     final appUser = AppUser.fromJson(userData);
        //     appUser.accessToken = token;
        //     print(appUser);
        //     HiveService().saveUser(appUser);
        //     print('Login Successfull: ${appUser.email}');
        //     return appUser;
        //   } else {
        //     print('User data is null or missing');
        //   }
        // } else {
        //   print('Login failed: ${response.data['message']}');
        // }
        final Map<String, dynamic> userData = {}; //response.data['data'];
        userData['accessToken'] = response.data['data']['accessToken'];
        userData['refreshToken'] = response.data['data']['refreshToken'];

        userData.addAll(response.data['data']['user']);
        if (userData.isNotEmpty) {
          final appUser = AppUser.fromJson(userData);
          await HiveService().saveUser(appUser);
          print('Login Successfull: ${appUser.fullName}');
          return appUser;
        } else {
          print("the user is null");
        }
      } else {
        print('Unexpected status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Login API Error: $e');
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserDocument(String uid) async {
    try {
      final snapshot = await firestore.collection('users').doc(uid).get();
      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }

  Future<void> storeUserDataInFirestore(User? user) async {
    if (user != null) {
      final userDoc = firestore.collection('users').doc(user.uid);
      final userSnapshot = await userDoc.get();

      if (!userSnapshot.exists) {
        await userDoc.set({
          'name': user.displayName,
          'email': user.email,
          'imageUrl': user.photoURL,
        });
      }
    }
  }

  Future<bool> signOut() async {
    try {
      await firebaseAuth.signOut();
      await GoogleSignIn().signOut();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //  Future<String?> refreshToken(String refreshToken) async {
  //   try {
  //     final response = await _dio.post(ApiConstants.refreshToken, data: {
  //       'refreshToken': refreshToken,
  //     });

  //     if (response.statusCode == 200 && response.data['success'] == true) {
  //       final newAccessToken = response.data['accessToken'];
  //       print('New Access Token: $newAccessToken');
  //       return newAccessToken;
  //     } else {
  //       print('Failed to refresh token: ${response.data['message']}');
  //     }
  //   } catch (e) {
  //     print('Refresh Token API Error: $e');
  //   }
  //   return null;
  // }

  Future<String?> refreshAuthToken(String refreshToken) async {
    try {
      final Map<String, dynamic> data = {'refreshToken': refreshToken};

      final response = await _dio.post(ApiConstants.refreshToken, data: data);

      if (response.statusCode == 200) {
        return response.data['accessToken'];
      } else {
        print("Failed to refresh the token: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error refreshing token: $e");
      return null;
    }
  }
}
