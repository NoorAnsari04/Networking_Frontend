import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_test_app_flavors/core/constants/font_constants.dart';
import 'package:my_test_app_flavors/core/constants/icon_constants.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/shared/user_avatar.dart';
import 'package:my_test_app_flavors/modules/auth/services/auth_provider.dart';

class UserInfoSection extends StatelessWidget {
  final AuthenticationProvider authProvider;

  const UserInfoSection({Key? key, required this.authProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = authProvider.appUser;
    final isStudent = user?.isStudent ?? false;

    return Column(
      children: [
        UserProfileAvatar(
          imageUrl: user?.imageUrl ?? '',
          name: user?.name,
          lastName: user?.lastName,
          outerRadius: 70.w,
          innerRadius: 60.w,
        ),
        10.height,
        Text(
          '${user?.fullName ?? ''}',
          style: kRaleway.copyWith(fontSize: 22.sp),
        ),
        10.height,
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              isStudent
                  ? IconConstants.universityIcon
                  : IconConstants.companyIcon,
              height: 24.h,
            ),
            SizedBox(width: 8.w),
            Text(
              isStudent
                  ? '${user?.instituteName ?? ''}'
                  : '${user?.company ?? ''}',
              style: kRaleway,
            ),
          ],
        ),
        10.height,
        Text(
          isStudent
              ? '${user?.degreeProgram ?? ''}'
              : '${user?.position ?? ''}',
          style: kRaleway.copyWith(
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
