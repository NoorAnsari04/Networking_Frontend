import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

extension TypographyUtils on BuildContext {
  ThemeData get theme => Theme.of(this);

  TextTheme get textTheme => theme.textTheme;

  // TextTheme get textTheme => GoogleFonts.montserratTextTheme(theme.textTheme);
  // ColorScheme get colors => theme.colorScheme;
  TextStyle? get displayLarge => textTheme.displayLarge?.copyWith(
        fontSize: 57.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        // color: ThemeColor.fontBlack,
      );

  TextStyle? get displayMedium => textTheme.displayMedium?.copyWith(
        fontSize: 28.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        // color: ThemeColor.fontBlack,
        height: 1.25,
      );

  TextStyle? get displaySmall => textTheme.displaySmall?.copyWith(
        fontSize: 22.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        // color: ThemeColor.fontBlack,
      );

  TextStyle? get headlineLarge => textTheme.headlineLarge?.copyWith(
        fontSize: 32.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        // color: ThemeColor.fontBlack,
      );

  TextStyle? get headlineMedium => textTheme.headlineMedium?.copyWith(
        fontSize: 28.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        // color: ThemeColor.fontBlack,
      );

  TextStyle? get headlineSmall => textTheme.headlineSmall?.copyWith(
        fontSize: 24.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        // color: ThemeColor.fontBlack,
      );

  TextStyle? get titleLarge => textTheme.titleLarge?.copyWith(
        height: 1.22,
        fontSize: 20.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        // color: ThemeColor.fontBlack,
      );

  TextStyle? get titleMedium => textTheme.titleMedium?.copyWith(
        fontSize: 20.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        // color: ThemeColor.fontBlack,
      );

  TextStyle? get titleSmall => textTheme.titleSmall?.copyWith(
        fontSize: 18.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        // color: ThemeColor.fontBlack,
        // height: 2
      );

  TextStyle? get labelLarge => textTheme.labelLarge?.copyWith(
        fontSize: 14.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        // color: ThemeColor.fontBlack,
      );

  TextStyle? get labelMedium => textTheme.labelMedium?.copyWith(
        fontSize: 10.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        // color: ThemeColor.fontBlack,
        height: 1.2,
      );

  TextStyle? get labelSmall => textTheme.labelSmall?.copyWith(
        fontSize: 10.sp,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w400,
        // color: ThemeColor.fontBlack,
      );

  TextStyle? get bodyLarge => textTheme.bodyLarge?.copyWith(
      fontSize: 16.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      // color: ThemeColor.fontBlack,
      height: 1.5);

  TextStyle? get bodyMedium => textTheme.bodyMedium?.copyWith(
      fontSize: 14.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      // color: ThemeColor.fontBlack,
      height: 1.5);

  TextStyle? get bodySmall => textTheme.bodySmall?.copyWith(
      fontSize: 12.sp,
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w400,
      // color: ThemeColor.fontBlack,
      height: 1.58);
}
