import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_test_app_flavors/core/constants/font_constants.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';

import '../../../core/constants/color_constants.dart';
import '../speakers/components/MeetingRequestButtons.dart';
import '../speakers/screens/meeting_request_screen.dart';

class ConnectionRequestList extends StatelessWidget {
  final AppUser user;
  final bool showApproveButton;
  final bool showDenyButton;
  final String requestId;
  final String sentUserId;
  final String meetingTitle;
  final Map<String, dynamic> requestData;
  final bool isSpeakerRequest;

  ConnectionRequestList({
    required this.user,
    required this.requestId,
    required this.sentUserId,
    required this.meetingTitle,
    required this.showApproveButton,
    required this.requestData,
    this.showDenyButton = false,
    this.isSpeakerRequest = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isStudent = user.isStudent ?? false;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isSpeakerRequest)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MeetingRequestScreen(
                            speaker: user,
                            requestData: requestData,
                            isViewOnly: true,
                          ),
                        ),
                      ),
                      child: Text(
                        'View form',
                        style: TextStyle(
                          color: ColorConstants.primaryColor,
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              if (!isSpeakerRequest) SizedBox(height: 8.h),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: user.imageUrl != null
                    ? CircleAvatar(
                        backgroundImage: NetworkImage(user.imageUrl as String))
                    : const CircleAvatar(child: Icon(Icons.person)),
                title: Text(user.fullName, style: bodyMediumTextStyle),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isStudent ? user.instituteName ?? '' : user.company ?? '',
                      style: smallTextStyle.copyWith(
                          fontSize: 10.sp, color: Colors.grey),
                    ),
                    Text(
                      isStudent
                          ? user.degreeProgram ?? ''
                          : user.position ?? '',
                      style: smallTextStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              if (isSpeakerRequest)
                MeetingRequestButtons(
                  requestId: requestId,
                  sentUserId: sentUserId,
                  showDenyButton: showDenyButton,
                  showApproveButton: showApproveButton,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
