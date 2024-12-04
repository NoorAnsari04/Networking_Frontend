import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/constants/color_constants.dart';
import '../../core/shared/custom_elevated_button.dart';

class ContactSupport extends StatelessWidget {
  static const id = 'ContactSupport';
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

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
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: SvgPicture.asset(
                      'assets/backward_arrow_head.svg',
                      height: 20.h,
                      width: 12.w,
                    ),
                  ),
                  SizedBox(
                    width: 70.w,
                  ),
                  Text(
                    'Contact Support',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryColor,
                      fontSize: 20.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 50.h),
            Center(
              child: Text(
                'How can we help you with?',
                style: TextStyle(fontSize: 18.sp),
              ),
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: subjectController,
              decoration: InputDecoration(
                hintText: 'Subject',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14.0.h, horizontal: 10.0.w),
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  subjectController.clear();
                }
              },
            ),
            SizedBox(height: 20.h),
            TextField(
              controller: messageController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Write your message',
                hintStyle: TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(vertical: 14.0.h, horizontal: 10.0.w),
              ),
              onChanged: (text) {
                if (text.isNotEmpty) {
                  messageController.clear();
                }
              },
            ),
            SizedBox(height: 20.h),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () {},
                  text: 'Submit',
                  manualAction: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
