import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constants.dart';
import 'font_constants.dart';

ThemeData theme(BuildContext context) {
  return ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: ColorConstants.primaryColor,
      secondary: ColorConstants.primaryColor,
    ),
    textTheme: TextTheme(
      headlineMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: ColorConstants.heading2,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      hintStyle: kFormFieldsTextStyle,
      fillColor: Colors.grey.shade200,
      filled: true,
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
    ),
  );
}
