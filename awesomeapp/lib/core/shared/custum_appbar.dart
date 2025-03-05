import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/font_constants.dart';

class CustomAppBar extends StatelessWidget {
  final String title;
  final String iconPath;
  final Color? titleColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    required this.iconPath,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50.0.w), // Adjust top padding as needed
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              padding: EdgeInsets.all(5),
              child: SvgPicture.asset(
                iconPath,
                height: 25.h,
                width: 15.w,
              ),
            ),
          ),
          // Spacer to push the title to the center
          Expanded(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: ktopTextStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ),
          ),
          // Placeholder to balance the Row (optional)
          SizedBox(width: 40.w), // Adjust width to match the back button's size
        ],
      ),
    );
  }
}
