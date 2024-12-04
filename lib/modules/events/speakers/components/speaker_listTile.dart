import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';
import 'package:my_test_app_flavors/modules/events/speakers/screens/speaker_profile.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/events/speakers/services/speaker_provider.dart';

class SpeakerListTile extends StatelessWidget {
  final AppUser speaker;
  final SpeakerProvider speakerProvider;
  final Widget Function(AppUser, SpeakerProvider) buildTrailingButton;

  const SpeakerListTile({
    Key? key,
    required this.speaker,
    required this.speakerProvider,
    required this.buildTrailingButton,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        leading: CircleAvatar(
          radius: 25.r,
          backgroundImage: NetworkImage(speaker.imageUrl ?? ''),
        ),
        title: Text(
          speaker.fullName ?? '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.sp,
            color: ColorConstants.primaryColor,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Worked in ${speaker.company ?? ''}',
              style: TextStyle(
                fontSize: 14.sp,
              ),
            ),
            Text(
              speaker.position ?? '',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
                color: ColorConstants.company,
              ),
            ),
          ],
        ),
        trailing: buildTrailingButton(speaker, speakerProvider),
        onTap: () {
          context.pushNamed(
            SpeakerProfile.id,
            extra: {'speaker': speaker},
          );
        },
      ),
    );
  }
}
