import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import '../../../core/services/validator.dart';
import '../../../core/shared/custom_elevated_button.dart';
import '../../../core/constants/font_constants.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool rememberMe;
  final ValueChanged<bool?> onRememberMeChanged;
  final VoidCallback onLogin;
  final VoidCallback onForgotPassword;

  const LoginForm({
    Key? key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onLogin,
    required this.onForgotPassword,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(hintText: 'Email'),
            validator: Validator.validateEmail,
          ),
          16.height,
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(hintText: 'Password'),
            obscureText: true,
            // validator: Validator.validatePassword,ss
          ),
          8.height,
          Row(
            children: [
              Checkbox(
                value: rememberMe,
                onChanged: onRememberMeChanged,
              ),
              Text('Remember me', style: bodysmallTextStyle),
            ],
          ),
          16.height,
          CustomElevatedButton(
            onPressed: onLogin,
            text: 'Login',
            manualAction: true,
          ),
          TextButton(
            onPressed: onForgotPassword,
            child: Text('Forgot password?', style: bodysmallTextStyle),
          ),
        ],
      ),
    );
  }
}
