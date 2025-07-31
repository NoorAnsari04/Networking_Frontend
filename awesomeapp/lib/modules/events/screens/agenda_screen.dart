import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/constants/color_constants.dart';

class AgendaScreen extends StatelessWidget {
  static const String id = 'agenda';

  final String imageUrl;

  const AgendaScreen({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20.h),
            SafeArea(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: SvgPicture.asset(
                        'assets/backward_arrow_head.svg',
                        height: 23.h,
                        width: 18.w,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      'Event Agenda',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.primaryColor,
                        fontSize: 22.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            Expanded(
              child: Center(
                child: imageUrl.isEmpty
                    ? const Text("No agenda image available.")
                    : Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const CircularProgressIndicator();
                  },
                  errorBuilder: (context, error, stackTrace) => const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.broken_image, size: 50, color: Colors.red),
                      SizedBox(height: 10),
                      Text("Failed to load image"),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
