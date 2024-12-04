import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import '../../core/constants/color_constants.dart';
import '../../core/constants/font_constants.dart';
import '../auth/services/app_user.dart';

class ConnectionCard extends StatelessWidget {
  final AppUser user;

  ConnectionCard({required this.user});

  @override
  Widget build(BuildContext context) {
    final bool isStudent = user.isStudent ?? false;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          user.fullName ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.sp,
            color: ColorConstants.primaryColor,
          ),
        ),
        8.height,
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                isStudent ? 'assets/university_bg.svg' : 'assets/company.svg',
                height: 24.h,
              ),
              SizedBox(width: 8.w),
              Text(
                isStudent ? user.instituteName ?? '' : user.company ?? '',
                style: ktopTextStyle.copyWith(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        8.height,
        Text(
          isStudent ? user.degreeProgram ?? '' : user.position ?? '',
          style: ktopTextStyle.copyWith(
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
