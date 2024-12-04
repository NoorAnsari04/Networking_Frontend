import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/modules/auth/screens/signup_screen.dart';
import 'package:provider/provider.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../auth/services/auth_provider.dart';
import '../components/user_info_section.dart';
import '../components/profile_action_card.dart';

class ProfileScreen extends StatelessWidget {
  static const id = '/profileScreen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<AuthenticationProvider>(
        builder: (context, authProv, _) {
          return Stack(
            children: [
              Container(
                color: ColorConstants.primaryColor,
                height: MediaQuery.of(context).size.height / 2,
              ),
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 2),
                color: Colors.white,
              ),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      60.height,
                      Center(child: UserInfoSection(authProvider: authProv)),
                      15.height,
                      ProfileActionCard(
                          onSignOut: () => _handleSignOut(context, authProv)),
                    ],
                  ),
                ),
              ),
              if (authProv.isLoading)
                Center(child: CircularProgressIndicator()),
            ],
          );
        },
      ),
    );
  }

  Future<void> _handleSignOut(
      BuildContext context, AuthenticationProvider authProv) async {
    final bool result = await authProv.signOut();

    if (result) {
      context.goNamed(SignupScreen.id);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Log out failed. Please try again.')),
      );
    }
  }
}
