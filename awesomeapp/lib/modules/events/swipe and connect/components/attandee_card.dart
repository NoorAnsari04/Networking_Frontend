import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';
import 'package:my_test_app_flavors/core/constants/icon_constants.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/shared/user_avatar.dart';
import '../../../../core/constants/font_constants.dart';

class AttendeeCard extends StatelessWidget {
  final String? imageUrl;
  final String name;
  final String lastName;
  final bool isStudent;
  final String company;
  final String position;
  final List<String> interests;
  final String description;
  final VoidCallback onSkip;
  final VoidCallback onConnect;
  final bool showSecondCard;
  final bool isReceivedRequest;

  const AttendeeCard({
    Key? key,
    this.imageUrl,
    required this.name,
    required this.lastName,
    required this.isStudent,
    required this.company,
    required this.position,
    required this.interests,
    required this.description,
    required this.onSkip,
    required this.onConnect,
    this.showSecondCard = true,
    this.isReceivedRequest = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (showSecondCard)
          Positioned(
            top: 28,
            left: 30.w,
            child: Container(
              width: 300.w,
              height: 590.h,
              decoration: BoxDecoration(
                color: ColorConstants.bgCard,
                borderRadius: BorderRadius.circular(55.0),
              ),
            ),
          ),
        Center(
          child: Container(
            width: 300.w,
            height: 590.h,
            margin: EdgeInsets.symmetric(horizontal: 10.w),
            decoration: BoxDecoration(
              color: ColorConstants.cardColor,
              borderRadius: BorderRadius.circular(35.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isReceivedRequest)
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                      color: ColorConstants.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(35.0),
                        topRight: Radius.circular(35.0),
                      ),
                    ),
                    child: Text(
                      'Wants to Connect With You',
                      textAlign: TextAlign.center,
                      style: kRaleway.copyWith(fontSize: 14),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      Center(
                        child: UserProfileAvatar(
                          imageUrl: imageUrl,
                          outerRadius: 65.w,
                          innerRadius: 55.w,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        '$name $lastName',
                        style: TextStyle(
                          fontSize: 20.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            isStudent
                                ? IconConstants.universityIcon
                                : IconConstants.companyIcon,
                          ),
                          SizedBox(width: 10),
                          Text(
                            company,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            isStudent ? IconConstants.degreeIcon : '',
                          ),
                          SizedBox(width: 10),
                          Text(
                            position,
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16.0.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Interests',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Wrap(
                                  children: interests
                                      .take(2)
                                      .map((interest) => Chip(
                                            label: Text(interest),
                                            backgroundColor:
                                                Colors.white.withOpacity(0.2),
                                            labelStyle:
                                                TextStyle(color: Colors.black),
                                          ))
                                      .toList(),
                                ),
                                Divider(color: Colors.white),
                                Text(
                                  'Description',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                8.height,
                                Text(
                                  description,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: onSkip,
                            style: ElevatedButton.styleFrom(
                              // primary: Colors.white,
                              // onPrimary: Colors.black,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 40.w, vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: Text('Skip'),
                          ),
                          ElevatedButton(
                            onPressed: onConnect,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 30.w, vertical: 12.h),
                            ),
                            child:
                                Text(isReceivedRequest ? 'Accept' : 'Connect'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
