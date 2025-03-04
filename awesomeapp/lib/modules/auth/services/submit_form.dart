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
import '../../events/screens/home_screen.dart';
import '../services/auth_provider.dart';
import 'package:dio/dio.dart' as dio;

void submitForm(
    
  BuildContext context,
  GlobalKey<FormState> formKey,
  FormData formData,
  Map<String, dynamic> signupData, {
  bool isGoogleSignIn = false,
      required AuthenticationProvider authProvider,
}) async {

  if (formKey.currentState!.validate()) {
    // final AuthenticationProvider authProvider;
    final dio.FormData formDatas = dio.FormData.fromMap({
      'userType': formData.selectedYear != null ? 'Student' : 'Industry Person',
      'company': formData.companyController.text.isNotEmpty
          ? formData.companyController.text
          : '',
      'yearOfExperience': formData.experienceController.text.isNotEmpty
          ? formData.experienceController.text
          : '',
      'designation': formData.positionController.text.isNotEmpty
          ? formData.positionController.text
          : '',
      'linkedInUrl': formData.linkedinUrlController.text.isNotEmpty
          ? formData.linkedinUrlController.text
          : '',
      'interests': formData.interests,
      'description': formData.descriptionController.text.isNotEmpty
          ? formData.descriptionController.text
          : '',
      'instituteName': formData.selectedInstitute ?? '',
      'yearOfGraduation': formData.selectedYear ?? '',
      'degreeProgram': formData.degreeProgramController.text.isNotEmpty
          ? formData.degreeProgramController.text
          : '',
      ...signupData,
    });

    log("Submitting user data: ${formDatas.fields}");

    final String url = ApiConstants.baseUrl + ApiConstants.userDetails;

    try {
      String? token = serviceLocator<AuthenticationProvider>().authToken();
      final dioInstance = DioClient.getDioInstance();
      // print("Access Token: $token");
      log("Access Token: $token");

      final response = await dioInstance.put(
        url,
        data: formDatas,
        options: dio.Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        log('User details updated successfully');

        final Map<String, dynamic> userData = response.data['data']['user'] ?? {};
        userData['accessToken'] = response.data['data']['accessToken'] ?? token;
        authProvider.updateUser(AppUser.fromJson(userData));
        // userData.addAll(response.data['data']['user']);

        log("Response data: ${jsonEncode(userData)}");

        if (userData.isNotEmpty) {
          final appUser = AppUser.fromJson(userData);
          log("Saving user: ${jsonEncode(appUser.toJson())}");
          await HiveService().saveUser(appUser);

          final savedUser = await HiveService().getUser();
          log("Saved User from Hive: ${jsonEncode(savedUser?.toJson())}");
        } else {
          log("User data is missing or empty.");
        }

        context.goNamed(HomeScreen.id);
      } else {
        log("Failed to update user details: ${response.data['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user details')),
        );
      }
    } catch (error) {
      log("Error updating user details: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to submit data: $error")),
      );
    }
  }
}
