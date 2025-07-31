import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_test_app_flavors/core/constants/api_constants.dart';
import '../../core/constants/color_constants.dart';
import '../../core/serviceLocator.dart';
import '../../core/shared/custom_elevated_button.dart';
import 'package:dio/dio.dart';

import '../auth/services/auth_provider.dart';

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
                      height: 23.h,
                      width: 25.w,
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
              // onChanged: (text) {
              //   if (text.isNotEmpty) {
              //     subjectController.clear();
              //   }
              // },
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
              // onChanged: (text) {
              //   if (text.isNotEmpty) {
              //     messageController.clear();
              //   }
              // },
            ),
            SizedBox(height: 20.h),
            Center(
              child: SizedBox(
                width: double.infinity,
                child: CustomElevatedButton(
                  onPressed: () async {
                    final subject = subjectController.text.trim();
                    final message = messageController.text.trim();

                    if (subject.isEmpty || message.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text("Subject and message are required.")),
                      );
                      return;
                    }
                    try {
                      final dio = Dio();
                      final token = await serviceLocator<
                          AuthenticationProvider>().authToken();
                      final url = ApiConstants.baseUrl +
                          ApiConstants.contactSupport;
                      final response = await dio.post(
                          url,
                          options: Options(
                              headers: {
                          "Authorization": "Bearer $token",
                          }
                          ),
                          data: {
                            'subject': subject,
                            'message': message
                          }
                      );
                      if (response.statusCode == 200 &&
                          response.data['success'] == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              "Support message sent successfully.")),
                        );
                        subjectController.clear();
                        messageController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response.data['message'] ??
                                "Failed to send message")));
                      }
                    } catch (e) {
                      print("Dio error: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(
                              "Something went wrong. Please try again later")));
                    }
                  },
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
