// import 'package:dio/dio.dart';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/core/constants/api_constants.dart';
import 'package:my_test_app_flavors/core/constants/dio_client.dart';
import 'package:my_test_app_flavors/core/serviceLocator.dart';
import 'package:my_test_app_flavors/core/services/hive_services.dart';
import 'package:my_test_app_flavors/modules/auth/components/form_data.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:provider/provider.dart';
import '../../events/screens/home_screen.dart';
import '../services/auth_provider.dart';
import 'package:dio/dio.dart' as dio;

void submitForm(
  BuildContext context,
  GlobalKey<FormState> formKey,
  FormData formData,
  Map<String, dynamic> signupData, {
  bool isGoogleSignIn = false,
}) async {
  if (formKey.currentState!.validate()) {
    dio.FormData formDatas = dio.FormData.fromMap({
      'userType': formData.selectedYear != null ? 'true' : 'false',
      'company': formData.companyController.text.isNotEmpty
          ? formData.companyController.text
          : null,
      'yearOfExperience': formData.experienceController.text.isNotEmpty
          ? formData.experienceController.text
          : null,
      'designation': formData.positionController.text.isNotEmpty
          ? formData.positionController.text
          : null,
      'linkedInUrl': formData.linkedinUrlController.text.isNotEmpty
          ? formData.linkedinUrlController.text
          : null,
      'interests': formData.interests,
      'description': formData.descriptionController.text.isNotEmpty
          ? formData.descriptionController.text
          : null,
      'instituteName': formData.selectedInstitute != null
          ? formData.selectedInstitute
          : null,
      'yearOfGraduation': formData.selectedYear,
      'degreeProgram': formData.degreeProgramController.text.isNotEmpty
          ? formData.degreeProgramController.text
          : null,
      ...signupData
    });

    log(jsonEncode({
      'userType': formData.selectedYear != null,
      'company': formData.companyController.text.isNotEmpty
          ? formData.companyController.text
          : null,
      'yearOfExperience': formData.experienceController.text.isNotEmpty
          ? formData.experienceController.text
          : null,
      'designation': formData.positionController.text.isNotEmpty
          ? formData.positionController.text
          : null,
      'linkedInUrl': formData.linkedinUrlController.text.isNotEmpty
          ? formData.linkedinUrlController.text
          : null,
      'interests': formData.interests.isNotEmpty,
      'description': formData.descriptionController.text.isNotEmpty
          ? formData.descriptionController.text
          : null,
      'instituteName': formData.selectedInstitute != null
          ? formData.selectedInstitute
          : null,
      'yearOfGraduation': formData.graduationYearController.text.isNotEmpty
          ? formData.graduationYearController.text
          : null,
      'degreeProgram': formData.degreeProgramController.text.isNotEmpty
          ? formData.degreeProgramController.text
          : null,
      ...signupData
    }));

    final completeUserData = formDatas;
    print('Complete User Data to be submitted: $completeUserData');

    final String url = ApiConstants.baseUrl + ApiConstants.userDetails;

    // Provider.of<AuthenticationProvider>(context, listen: false)
    //     .createUserDocument(completeUserData, isGoogleSignIn: isGoogleSignIn)
    //     .then((_) {
    //   print("Document created/updated successfully, navigating to HomeScreen");
    //   context.goNamed(HomeScreen.id);
    // }).catchError((error) {
    //   print("Error creating/updating document: $error");
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Failed to submit data: $error')),
    //   );
    // });
    try {
      String? token = serviceLocator<AuthenticationProvider>().authToken();
      final dioInstance = DioClient.getDioInstance();
      print("Access Token: $token");
      final response = await dioInstance.put(url,
          data: completeUserData,
          options: dio.Options(headers: {'Authorization': 'Bearer $token'}));

      // if (response.statusCode == 200 && response.data['success'] == true) {
      //   print('User details updated successfully, navigating to HomeScreen');
      //   final userData = response.data['data']['user'];
      //   print("Response data: $userData");
      //   final token = response.data['data']['accessToken'];
      //   print(
      //       "User data received: ${userData.toString()}"); // Print full user data
      //   userData['accessToken'] = token;
      //   userData.addAll(response.data['data']['user']);

      //   if (userData != null) {
      //     final appUser = AppUser.fromJson({...userData});
      //     print("AppUser being saved: ${appUser.toJson()}");
      //     await HiveService().saveUser(appUser);
      //     final savedUser = await HiveService().getUser();
      //     print("Saved User from Hive: ${savedUser?.toJson()}");
      //   }
      //   context.goNamed(HomeScreen.id);
      // } else {
      //   print("Failed to upload user details: ${response.data['message']}");
      //   ScaffoldMessenger.of(context).showSnackBar(
      //     SnackBar(content: Text('Failed to update user details')),
      //   );
      // }
      if (response.statusCode == 200 && response.data['success'] == true) {
        print('User details updated successfully, navigating to HomeScreen');

        final Map<String, dynamic> userData = {}; // Initialize as an empty map
        userData['accessToken'] = response.data['data']['accessToken'] ?? token;
        // userData['refreshToken'] = response.data['data']['refreshToken'];
        userData.addAll(response.data['data']['user']);

        print("Response data: $userData");
        print(
            "User data received: ${userData.toString()}"); // Print full user data

        if (userData.isNotEmpty) {
          final appUser = AppUser.fromJson(userData);
          print("AppUser being saved: ${appUser.toJson()}");
          await HiveService().saveUser(appUser);

          final savedUser = await HiveService().getUser();
          print("Saved User from Hive: ${savedUser?.toJson()}");
        } else {
          print("User data is null or missing");
        }

        context.goNamed(HomeScreen.id);
      } else {
        print('Failed to update user details: ${response.data['message']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user details')),
        );
      }
    } catch (error) {
      print("Error updating user details: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit data: $error")),
      );
    }
  }
}
