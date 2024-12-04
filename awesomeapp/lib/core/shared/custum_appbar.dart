import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/font_constants.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color? titleColor; // Add a titleColor parameter

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.iconPath,
    this.titleColor, // Add a titleColor parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 50.0.w, left: 10, right: 10),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgPicture.asset(
                  iconPath,
                  height: 25.h,
                  width: 15.w,
                ),
              ),
              SizedBox(width: 110.w),
              Text(
                title,
                textAlign: TextAlign.center,
                style: ktopTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
