import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import '../../../core/services/validator.dart';
import '../../../core/shared/custom_elevated_button.dart';

class SignupForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final VoidCallback onSignup;

  const SignupForm({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.lastNameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.onSignup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            controller: nameController,
            decoration: InputDecoration(hintText: 'First Name'),
            validator: Validator.validateFields,
          ),
          10.height,
          TextFormField(
            controller: lastNameController,
            decoration: InputDecoration(hintText: 'Last Name'),
            validator: Validator.validateFields,
          ),
          10.height,
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(hintText: 'Work Email'),
            validator: Validator.validateEmail,
          ),
          10.height,
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(hintText: 'Password'),
            obscureText: true,
            validator: Validator.validatePassword,
          ),
          10.height,
          TextFormField(
            controller: confirmPasswordController,
            decoration: InputDecoration(hintText: 'Confirm Password'),
            obscureText: true,
            validator: (value) {
              if (value != passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
          ),
          10.height,
          CustomElevatedButton(
            onPressed: onSignup,
            text: 'Sign Up',
            manualAction: true,
          ),
        ],
      ),
    );
  }
}
