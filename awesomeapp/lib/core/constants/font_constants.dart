import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'color_constants.dart';

const String kRalewayMedium = "RalewayMedium";
const String kRalewaySemiBold = "RalewaySemiBold";
const String kRalewayExtraBold = "RalewayExtraBold";
const String kRalewayBold = "RalewayBold";
const String kRalewayRegular = "RalewayRegular";

final kTitleTextStyle = TextStyle(
  fontSize: 24.0.sp,
  fontWeight: FontWeight.w700,
  color: ColorConstants.primaryColor,
  fontFamily: kRalewayBold,
);

//For Selected tab
final ktopTextStyle = TextStyle(
  fontSize: 22.0.sp,
  color: ColorConstants.primaryColor,
  fontFamily: kRalewaySemiBold,
);

final kRaleway = TextStyle(
  color: Colors.white,
  fontSize: 18,
  fontFamily: kRalewaySemiBold,
);

final ticketlabel = TextStyle(
  fontSize: 12,
  fontFamily: kRalewayMedium,
);

final ticketText = TextStyle(
  fontSize: 12,
  fontFamily: kRalewayMedium,
  color: ColorConstants.primaryColor,
);
final kFormFieldsTextStyle = TextStyle(
  color: Color(0xFF999999),
  fontFamily: kRalewayMedium,
  fontSize: 14.0.sp,
  fontWeight: FontWeight.w500,
);

final bodysmallTextStyle = TextStyle(
  fontWeight: FontWeight.w600,
  fontSize: 12.sp,
  fontFamily: kRalewayMedium,
  color: ColorConstants.primaryColor,
);

final bodyMediumTextStyle = TextStyle(
  fontWeight: FontWeight.w700,
  fontSize: 16.sp,
  fontFamily: kRalewayMedium,
  color: ColorConstants.primaryColor,
);

final smallTextStyle = TextStyle(
  fontSize: 12.sp,
  fontFamily: kRalewayRegular,
  color: ColorConstants.company,
);

final searchInputDecoration = InputDecoration(
  fillColor: Colors.transparent,
  filled: true,
  suffixIcon: Icon(Icons.search),
  hintText: 'Search',
  hintStyle: TextStyle(color: ColorConstants.primaryColor),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      color: Color(0xFF422A7E),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      color: Color(0xFF422A7E),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8.0),
    borderSide: BorderSide(
      color: Color(0xFF422A7E),
    ),
  ),
);

final divider = Divider(thickness: 2, color: Color(0xFFE1DFDF));
