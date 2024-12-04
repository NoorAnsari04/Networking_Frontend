import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/events/speakers/components/speaker_card_details.dart';
import '../../../../core/shared/user_avatar.dart';

class SpeakerCard extends StatelessWidget {
  final AppUser speaker;
  final String shortLinkedInUrl;

  const SpeakerCard({
    Key? key,
    required this.speaker,
    required this.shortLinkedInUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            child: Card(
              child: Padding(
                padding: EdgeInsets.only(
                  top: 90.h,
                  left: 16.w,
                  right: 16.w,
                  bottom: 16.w,
                ),
                child: SpeakerCardDetails(
                  speaker: speaker,
                  shortLinkedInUrl: shortLinkedInUrl,
                ),
              ),
            ),
          ),
          Positioned(
            top: -90.h,
            left: 0,
            right: 0,
            child: Center(
              child: UserProfileAvatar(
                imageUrl: speaker.imageUrl,
                outerRadius: 85.w,
                innerRadius: 75.w,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
