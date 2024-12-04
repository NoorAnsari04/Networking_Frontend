import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/services/helper_function.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';

class SpeakerCardDetails extends StatelessWidget {
  final AppUser speaker;
  final String shortLinkedInUrl;

  const SpeakerCardDetails({
    Key? key,
    required this.speaker,
    required this.shortLinkedInUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          speaker.fullName,
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
                'assets/company.svg',
                height: 24.h,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                speaker.company!,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: ColorConstants.company,
                ),
              ),
            ],
          ),
        ),
        8.height,
        Text(
          speaker.position!,
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorConstants.company,
          ),
        ),
        16.height,
        Text(
          speaker.description ?? 'No bio available',
          style: TextStyle(
            fontSize: 14.sp,
            color: ColorConstants.company,
          ),
          textAlign: TextAlign.center,
        ),
        16.height,
        Divider(),
        Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _buildStatistics(),
              Divider(),
              16.height,
              _buildContactInfo(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatistics() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: _buildStatItem(
            icon: 'assets/session.svg',
            title: 'Delivered \n Session',
            value: speaker.sessionsDeliver.toString(),
          ),
        ),
        Container(
          height: 60.h,
          child: VerticalDivider(
            thickness: 2,
            color: Color(0xFFE1DFDF),
          ),
        ),
        Expanded(
          child: _buildStatItem(
            icon: 'assets/experience.svg',
            title: 'Experience',
            value: '${speaker.experience}+ Years',
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
      {required String icon, required String title, required String value}) {
    return Column(
      children: [
        SvgPicture.asset(
          icon,
          height: 24.h,
        ),
        10.height,
        Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
          ),
          textAlign: TextAlign.center,
        ),
        15.height,
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.email),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () async {
                await HelperFunction.sendEmail(speaker.email);
              },
              child: Text(speaker.email),
            ),
          ],
        ),
        Divider(),
        8.height,
        Row(
          children: [
            SvgPicture.asset(
              'assets/linkedin.svg',
              height: 24.h,
            ),
            SizedBox(
              width: 8,
            ),
            InkWell(
              onTap: () {
                HelperFunction.goToWebPage(speaker.linkedinUrl!);
              },
              child: Text(shortLinkedInUrl),
            ),
          ],
        ),
      ],
    );
  }
}
