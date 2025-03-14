import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:my_test_app_flavors/modules/events/speakers/services/speaker_provider.dart';

class MeetingRequestButtons extends StatelessWidget {
  final String requestId;
  final String senderId;
  final bool showDenyButton;
  final bool showApproveButton;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  const MeetingRequestButtons({
    Key? key,
    required this.requestId,
    required this.senderId,
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
                // await provider.rejectMeetingRequest(requestId);
                // onReject!();
                try {
                  await provider.handleMeetingRequest(
                      requestId: requestId,
                      senderId: senderId,
                      receiverId: provider.getCurrentUserId() ?? '',
                      action: 'Deny');
                  onReject?.call();
                } catch (e) {
                  print("Error rejecting meeting request: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to reject request: $e")));
                }
              },
              child: Text('Deny'),
            ),
          ),
        if (showDenyButton && showApproveButton) SizedBox(width: 16.w),
        if (showApproveButton)
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                // await provider.acceptMeetingRequest(requestId, sentUserId);
                // onAccept!();
                try {
                  await provider.handleMeetingRequest(
                      requestId: requestId,
                      senderId: senderId,
                      receiverId: provider.getCurrentUserId() ?? "",
                      action: "Approve");
                  onAccept?.call();
                } catch (e) {
                  print("Error accepting meeting request:$e");
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Failed to accept request: $e")));
                }
              },
              child: Text('Approve'),
            ),
          ),
      ],
    );
  }
}
