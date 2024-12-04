import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/extensions/scaffold_message.dart';
import 'package:my_test_app_flavors/modules/auth/screens/user_details_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/font_constants.dart';
import '../../../core/constants/icon_constants.dart';
import '../../events/screens/home_screen.dart';
import '../services/auth_provider.dart';
import 'login_screen.dart';
import '../components/signup_form.dart';
import '../components/social_login_buttons.dart';

class SignupScreen extends StatefulWidget {
  static const id = 'signUp';

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _genderController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _genderController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final success =
          await Provider.of<AuthenticationProvider>(context, listen: false)
              .signUp(_emailController.text, _passwordController.text);

      if (success) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserDetailsScreen(
              signupData: {
                'email': _emailController.text,
                'name': _nameController.text,
                'lastName': _lastNameController.text,
              },
            ),
          ),
        );
      } else {
        context.showSnackBar('SignUp Failed');
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authProc =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final success = await authProc.googleSignIn();
    if (!mounted) return;

    if (success) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Check if the user document already exists
        final documentExists = await authProc.isUserDocumentExist();

        if (documentExists) {
          // If the document exists, go directly to the HomeScreen
          context.goNamed(HomeScreen.id);
        } else {
          // If the document doesn't exist, prepare signupData and go to UserDetailsScreen
          final signupData = {
            'email': user.email,
            'name': user.displayName,
            'imageUrl': user.photoURL,
          };

          context.goNamed(UserDetailsScreen.id,
              extra: {'signupData': signupData, 'isGoogleSignIn': true});
        }
      }
    } else {
      context.showSnackBar('Google Login Failed');
    }
  }

  void _handleAppleSignIn() {
    // Handle Apple sign-in
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthenticationProvider>(context).isLoading;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            child: SvgPicture.asset(
              IconConstants.designTop1,
              width: 100.w,
              height: 130.h,
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: SvgPicture.asset(
              IconConstants.designBottom1,
              width: 100.w,
              height: 100.h,
            ),
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0.w),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Sign Up', style: ktopTextStyle),
                      30.height,
                      SignupForm(
                        formKey: _formKey,
                        nameController: _nameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        onSignup: _handleSignUp,
                      ),
                      TextButton(
                        onPressed: () => context.pushNamed(LoginScreen.id),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'Sign In',
                                style: bodysmallTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SocialLoginButtons(
                        onGoogleSignIn: _handleGoogleSignIn,
                        onAppleSignIn: _handleAppleSignIn,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
