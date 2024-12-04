// meeting_request_form_content.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_test_app_flavors/core/constants/icon_constants.dart';
import 'package:my_test_app_flavors/core/constants/font_constants.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/shared/user_avatar.dart';
import 'package:my_test_app_flavors/core/shared/custom_elevated_button.dart';
import 'package:my_test_app_flavors/modules/events/attandees/components/custum_form_fields.dart';
import 'package:my_test_app_flavors/modules/events/speakers/components/MeetingRequestButtons.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';

class MeetingRequestForm extends StatelessWidget {
  final AppUser speaker;
  final bool isViewOnly;
  final bool isStudentRequest;
  final GlobalKey<FormState> formKey;
  final TextEditingController meetingTitleController;
  final TextEditingController attendeeNameController;
  final TextEditingController companyController;
  final TextEditingController positionController;
  final TextEditingController universityController;
  final TextEditingController degreeProgramController;
  final TextEditingController emailController;
  final VoidCallback submitForm;
  final Map<String, dynamic>? requestData;

  const MeetingRequestForm({
    Key? key,
    required this.speaker,
    required this.isViewOnly,
    required this.isStudentRequest,
    required this.formKey,
    required this.meetingTitleController,
    required this.attendeeNameController,
    required this.companyController,
    required this.positionController,
    required this.universityController,
    required this.degreeProgramController,
    required this.emailController,
    required this.submitForm,
    this.requestData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height / 4 - 85.h),
        UserProfileAvatar(
          imageUrl: speaker.imageUrl,
          outerRadius: 46.w,
          innerRadius: 40.w,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Center(
                    child: Column(children: [
                      if (!isViewOnly)
                        Text(
                          'Speaker',
                          style: bodysmallTextStyle,
                        ),
                      10.height,
                      Text(
                        speaker.fullName,
                        style: bodyMediumTextStyle,
                      ),
                    ]),
                  ),
                ),
                SizedBox(height: 10.h),
                CustomFormField(
                  label: 'Meeting Reason',
                  icon: SvgPicture.asset(
                    IconConstants.titleIcon,
                    height: 24.h,
                  ),
                  controller: meetingTitleController,
                  readOnly: isViewOnly,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a meeting reason';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                CustomFormField(
                  label: 'Attendee Name',
                  icon: Icon(Icons.person_outline),
                  controller: attendeeNameController,
                  readOnly: isViewOnly,
                ),
                16.height,
                if (isStudentRequest)
                  CustomFormField(
                    label: 'University',
                    icon: SvgPicture.asset(
                      IconConstants.universityIcon,
                      height: 24.h,
                    ),
                    controller: universityController,
                    readOnly: isViewOnly,
                  )
                else
                  CustomFormField(
                    label: 'Company',
                    icon: Icon(Icons.business),
                    controller: companyController,
                    readOnly: isViewOnly,
                  ),
                16.height,
                if (isStudentRequest)
                  CustomFormField(
                    label: 'Degree Program',
                    icon: SvgPicture.asset(
                      IconConstants.degreeIcon,
                    ),
                    controller: degreeProgramController,
                    readOnly: isViewOnly,
                  )
                else
                  CustomFormField(
                    label: 'Position',
                    icon: SvgPicture.asset(
                      IconConstants.PositionIcon,
                    ),
                    controller: positionController,
                    readOnly: isViewOnly,
                  ),
                16.height,
                CustomFormField(
                  label: 'Email',
                  icon: Icon(Icons.email_outlined),
                  controller: emailController,
                  readOnly: isViewOnly,
                ),
                16.height,
                if (!isViewOnly)
                  CustomElevatedButton(
                    text: 'Submit',
                    manualAction: true,
                    onPressed: submitForm,
                  )
                else if (isViewOnly)
                  MeetingRequestButtons(
                    requestId: requestData!['id'],
                    sentUserId: requestData!['senderId'],
                    onAccept: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Meeting request accepted successfully!')),
                      );
                      Navigator.of(context).pop();
                    },
                    onReject: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content:
                                Text('Meeting request rejected successfully!')),
                      );
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
