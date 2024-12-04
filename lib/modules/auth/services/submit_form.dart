import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/modules/auth/components/form_data.dart';
import 'package:provider/provider.dart';
import '../../events/screens/home_screen.dart';
import '../services/auth_provider.dart';

void submitForm(
  BuildContext context,
  GlobalKey<FormState> formKey,
  FormData formData,
  Map<String, dynamic> signupData, {
  bool isGoogleSignIn = false,
}) {
  if (formKey.currentState!.validate()) {
    final userDetails = {
      'isStudent': formData.selectedYear != null,
      'company': formData.selectedYear == null
          ? formData.companyController.text
          : null,
      'experience': formData.selectedYear == null
          ? formData.experienceController.text
          : null,
      'position': formData.selectedYear == null
          ? formData.positionController.text
          : null,
      'degreeProgram': formData.selectedYear != null
          ? formData.degreeProgramController.text
          : null,
      'yearOfGraduation': formData.selectedYear,
      'instituteName': formData.selectedInstitute,
      'linkedinUrl': formData.linkedinUrlController.text,
      'description': formData.descriptionController.text,
      'interests': formData.interests,
    };

    final completeUserData = {...signupData, ...userDetails};

    Provider.of<AuthenticationProvider>(context, listen: false)
        .createUserDocument(completeUserData, isGoogleSignIn: isGoogleSignIn)
        .then((_) {
      print("Document created/updated successfully, navigating to HomeScreen");
      context.goNamed(HomeScreen.id);
    }).catchError((error) {
      print("Error creating/updating document: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit data: $error')),
      );
    });
  }
}
