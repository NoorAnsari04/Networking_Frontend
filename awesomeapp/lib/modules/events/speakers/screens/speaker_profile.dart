import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import '../components/speaker_card.dart';

class SpeakerProfile extends StatefulWidget {
  static const id = 'speakerProfile';
  final AppUser speaker;

  SpeakerProfile({required this.speaker});

  @override
  _SpeakerProfileState createState() => _SpeakerProfileState();
}

class _SpeakerProfileState extends State<SpeakerProfile> {
  String shortLinkedInUrl = '';

  @override
  void initState() {
    super.initState();
    getShortLink(widget.speaker.linkedinUrl);
  }

  Future<void> getShortLink(String? url) async {
    if (url != null && url.isNotEmpty) {
      setState(() {
        shortLinkedInUrl = Uri.parse(url).host;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 3,
            color: ColorConstants.primaryColor,
          ),
          Padding(
            padding: EdgeInsets.only(top: 38.h, left: 16.w),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                'assets/arrow_icon.svg',
                height: 27.h,
                width: 17.w,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(top: 50.0.h, left: 16.w, right: 16.w),
              child: SpeakerCard(
                speaker: widget.speaker,
                shortLinkedInUrl: shortLinkedInUrl,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
