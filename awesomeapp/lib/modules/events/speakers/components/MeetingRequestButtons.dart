import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:my_test_app_flavors/modules/events/speakers/services/speaker_provider.dart';

class MeetingRequestButtons extends StatelessWidget {
  final String requestId;
  final String sentUserId;
  final bool showDenyButton;
  final bool showApproveButton;
  final Function()? onAccept;
  final Function()? onReject;

  const MeetingRequestButtons({
    Key? key,
    required this.requestId,
    required this.sentUserId,
    this.showDenyButton = true,
    this.showApproveButton = true,
    this.onAccept,
    this.onReject,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SpeakerProvider>(context, listen: false);

    return Row(
      children: [
        if (showDenyButton)
          Expanded(
            child: OutlinedButton(
              onPressed: () async {
                await provider.rejectMeetingRequest(requestId);
                onReject!();
              },
              child: Text('Deny'),
            ),
          ),
        if (showDenyButton && showApproveButton) SizedBox(width: 16.w),
        if (showApproveButton)
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                await provider.acceptMeetingRequest(requestId, sentUserId);
                onAccept!();
              },
              child: Text('Approve'),
            ),
          ),
      ],
    );
  }
}
