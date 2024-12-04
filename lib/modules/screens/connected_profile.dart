// connected_profiles.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/modules/componenets/connection_card.dart';
import 'package:my_test_app_flavors/modules/componenets/connection_card_details.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/icon_constants.dart';
import '../../core/shared/custum_appbar.dart';
import '../../core/shared/user_avatar.dart';
import '../auth/services/app_user.dart';

class ConnectedProfiles extends StatelessWidget {
  static const id = 'connectionDetails';
  final AppUser user;

  ConnectedProfiles({required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 2,
            color: ColorConstants.primaryColor,
          ),
          CustomAppBar(
            title: 'Connected',
            iconPath: IconConstants.backward_arrow,
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0.h, left: 16.w, right: 16.w),
              child: Container(
                width: 350.w,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    SingleChildScrollView(
                      child: Card(
                        color: ColorConstants.cardColor,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.0.w,
                            vertical: 16.0.w,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              90.height,
                              ConnectionCard(user: user),
                              20.height,
                              ConnectionCardDetails(user: user),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: -90.h,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: UserProfileAvatar(
                          imageUrl: user.imageUrl,
                          outerRadius: 90.w,
                          innerRadius: 80.w,
                        ),
                      ),
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
