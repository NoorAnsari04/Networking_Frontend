import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_test_app_flavors/core/constants/font_constants.dart';
import 'package:my_test_app_flavors/core/constants/icon_constants.dart';
import 'package:my_test_app_flavors/modules/auth/services/app_user.dart';
import 'package:my_test_app_flavors/modules/events/speakers/services/speaker_provider.dart';

import '../../core/shared/custum_appbar.dart';
import '../events/components/connection_request_list.dart';

class ConnectionRequestsScreen extends StatelessWidget {
  static const id = 'connection_requests';

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SpeakerProvider(),
      child: ConnectionRequestsContent(),
    );
  }
}

class ConnectionRequestsContent extends StatefulWidget {
  @override
  _ConnectionRequestsContentState createState() =>
      _ConnectionRequestsContentState();
}

class _ConnectionRequestsContentState extends State<ConnectionRequestsContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SpeakerProvider>(context, listen: false)
          .fetchMeetingRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(
          title: 'Pending Requests',
          iconPath: IconConstants.backward_arrow,
        ),
      ),
      body: Consumer<SpeakerProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }
          if (provider.meetingRequests.isEmpty) {
            return Center(
              child: Text(
                'No pending requests available.',
                style: bodyMediumTextStyle,
              ),
            );
          }
          return ListView.builder(
            itemCount: provider.meetingRequests.length,
            itemBuilder: (context, index) {
              final request = provider.meetingRequests[index];
              final user = AppUser.fromJson(request['user']);
              final isSpeakerRequest =
                  request['request']['meetingTitle'] == null ||
                      request['request']['meetingTitle'].isEmpty;
              return ConnectionRequestList(
                user: user,
                requestId: request['request']['id'],
                sentUserId: request['request']['senderId'],
                meetingTitle: request['request']['meetingTitle'] ?? '',
                showApproveButton: true,
                showDenyButton: true,
                requestData: request['request'],
                isSpeakerRequest: isSpeakerRequest,
              );
            },
          );
        },
      ),
    );
  }
}
