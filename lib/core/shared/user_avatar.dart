import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:io';

import 'package:my_test_app_flavors/core/constants/icon_constants.dart';

class UserProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? name;
  final String? lastName;
  final double outerRadius;
  final double innerRadius;
  final Color outerBackgroundColor;
  final TextStyle textStyle;
  final bool isEditable;
  final void Function()? onEditTap;
  final File? newImage;

  const UserProfileAvatar({
    Key? key,
    required this.imageUrl,
    this.name,
    this.lastName,
    this.outerRadius = 85,
    this.innerRadius = 75,
    this.outerBackgroundColor = Colors.white,
    this.textStyle = const TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
    ),
    this.isEditable = false,
    this.onEditTap,
    this.newImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isEditable ? onEditTap : null,
      child: CircleAvatar(
        radius: outerRadius,
        backgroundColor: outerBackgroundColor,
        child: Stack(
          children: [
            CircleAvatar(
              radius: innerRadius,
              backgroundImage: newImage != null
                  ? FileImage(newImage!)
                  : (imageUrl != null && imageUrl!.isNotEmpty)
                      ? (imageUrl!.startsWith('http')
                          ? NetworkImage(imageUrl!)
                          : FileImage(File(imageUrl!)) as ImageProvider<Object>)
                      : null,
              child: (imageUrl == null || imageUrl!.isEmpty)
                  ? Center(
                      child: Text(
                        '${name?.isNotEmpty == true ? name![0] : ''}${lastName?.isNotEmpty == true ? lastName![0] : ''}',
                        style: textStyle.copyWith(
                          color: Colors.grey[800],
                        ),
                      ),
                    )
                  : null,
            ),
            if (isEditable)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  radius: 16.r,
                  backgroundColor: Colors.white,
                  child: SvgPicture.asset(
                    IconConstants.editIcon,
                    height: 24.h,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
