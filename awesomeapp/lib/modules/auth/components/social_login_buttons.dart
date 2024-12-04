import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import '../../../core/constants/icon_constants.dart';
import '../../../core/shared/custom_elevated_button.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGoogleSignIn;
  final VoidCallback onAppleSignIn;

  const SocialLoginButtons({
    Key? key,
    required this.onGoogleSignIn,
    required this.onAppleSignIn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomElevatedButton(
          icon: Image.asset(IconConstants.googleIcon, height: 24.h),
          text: 'Google',
          onPressed: onGoogleSignIn,
        ),
        10.height,
        CustomElevatedButton(
          icon: Image.asset(IconConstants.appleIcon, height: 24.h),
          text: 'Apple',
          onPressed: onAppleSignIn,
        ),
      ],
    );
  }
}
