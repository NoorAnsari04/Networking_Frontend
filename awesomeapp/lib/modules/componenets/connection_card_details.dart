// user_details_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import '../../core/constants/font_constants.dart';
import '../../core/services/helper_function.dart';
import '../auth/services/app_user.dart';

class ConnectionCardDetails extends StatelessWidget {
  final AppUser user;

  ConnectionCardDetails({required this.user});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(16.0.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/linkedin.svg',
                    height: 24.h,
                  ),
                  SizedBox(width: 8.w),
                  InkWell(
                    onTap: () {
                      if (user.linkedinUrl != null) {
                        HelperFunction.goToWebPage(user.linkedinUrl!);
                      }
                    },
                    child: Text(
                      user.linkedinUrl != null
                          ? Uri.parse(user.linkedinUrl!).host ?? ''
                          : '',
                      style: ktopTextStyle.copyWith(
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              Divider(),
              8.height,
              Text(
                'Description',
                style: ktopTextStyle.copyWith(
                  fontSize: 16,
                ),
              ),
              8.height,
              Text(
                user.description ?? 'No bio available',
                style: ktopTextStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
