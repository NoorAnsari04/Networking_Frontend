import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../../auth/services/app_user.dart';
import 'attandee_card.dart';
import '../services/swipe_connect_provider.dart';

class BackgroundConnectWidget extends StatelessWidget {
  final AppUser connect;
  final double opacity;
  final Color color;
  final bool showSecondCard;
  final String conferenceId;
  const BackgroundConnectWidget({
    Key? key,
    required this.connect,
    required this.opacity,
    required this.color,
    required this.showSecondCard,
    required this.conferenceId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Stack(
        children: [
          AttendeeCard(
            imageUrl: connect.imageUrl,
            name: connect.name,
            lastName: connect.lastName,
            isStudent: connect.userType == 'Student',
            company: connect.userType == 'Student'
                ? connect.instituteName ?? ''
                : connect.company ?? '',
            position: connect.userType == 'Student'
                ? connect.degreeProgram ?? ''
                : connect.position ?? '',
            interests: connect.interests ?? [],
            description: connect.description ?? '',
            onSkip: () {
              final provider =
                  Provider.of<SwipeAndConnectProvider>(context, listen: false);
              provider.swipeAndConnectAction(receiverId: connect.id, action: false,conferenceId: conferenceId );
            },
            onConnect: () {
              final provider =
                  Provider.of<SwipeAndConnectProvider>(context, listen: false);
              provider.swipeAndConnectAction(receiverId: connect.id, action: true, conferenceId: conferenceId);
            },
            showSecondCard: showSecondCard,
          ),
          Container(
            height: 1.sh,
            width: 1.sw,
            // color: color.withOpacity(
            //   1.0 - opacity,
            // ),
            color: Colors.transparent,
          ),
        ],
      ),
    );
  }
}
