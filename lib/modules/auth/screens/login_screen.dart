import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/extensions/scaffold_message.dart';
import 'package:my_test_app_flavors/modules/auth/screens/user_details_screen.dart';
import 'package:provider/provider.dart';
import '../../../core/constants/font_constants.dart';
import '../../../core/constants/icon_constants.dart';
import '../../events/screens/home_screen.dart';
import '../screens/forget_password_screen.dart';
import '../screens/signup_screen.dart';
import '../components/login_form.dart';
import '../components/social_login_buttons.dart';
import '../services/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  static const id = 'login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadUserCredentials();
  }

  Future<void> _loadUserCredentials() async {
    final credentials = await AuthenticationProvider.loadUserCredentials();
    setState(() {
      _emailController.text = credentials['email'];
      _passwordController.text = credentials['password'];
      _rememberMe = credentials['rememberMe'];
    });
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProc =
          Provider.of<AuthenticationProvider>(context, listen: false);
      final success = await authProc.login(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      if (success) {
        await AuthenticationProvider.saveUserCredentials(
          _emailController.text,
          _passwordController.text,
          _rememberMe,
        );
        context.showSnackBar('Login Successful');

        context.goNamed(
          HomeScreen.id,
        );
      } else {
        context.showSnackBar('Login failed');
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    final authProc =
        Provider.of<AuthenticationProvider>(context, listen: false);
    final success = await authProc.googleSignIn();
    if (!mounted) return;

    if (success) {
      // Get the current user
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
            // Add any other data you want to pre-fill
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
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = Provider.of<AuthenticationProvider>(context).isLoading;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            right: 0,
            child: SvgPicture.asset(IconConstants.designTop,
                width: 100.w, height: 130.h),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SvgPicture.asset(IconConstants.designBottom,
                width: 100.w, height: 100.h),
          ),
          if (isLoading)
            Center(child: CircularProgressIndicator())
          else
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.0.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Welcome To Networking', style: kTitleTextStyle),
                    16.height,
                    Text('Login', style: ktopTextStyle),
                    32.height,
                    LoginForm(
                      formKey: _formKey,
                      emailController: _emailController,
                      passwordController: _passwordController,
                      rememberMe: _rememberMe,
                      onRememberMeChanged: (value) =>
                          setState(() => _rememberMe = value!),
                      onLogin: _handleLogin,
                      onForgotPassword: () =>
                          context.pushNamed(ForgetPasswordPage.id),
                    ),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                                text: 'Don\'t have an account? ',
                                style: TextStyle(color: Colors.black)),
                            TextSpan(
                              text: 'Sign Up',
                              style: bodysmallTextStyle,
                              recognizer: TapGestureRecognizer()
                                ..onTap =
                                    () => context.pushNamed(SignupScreen.id),
                            ),
                          ],
                        ),
                      ),
                    ),
                    16.height,
                    SocialLoginButtons(
                      onGoogleSignIn: _handleGoogleSignIn,
                      onAppleSignIn: _handleAppleSignIn,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
