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

  const BackgroundConnectWidget({
    Key? key,
    required this.connect,
    required this.opacity,
    required this.color,
    required this.showSecondCard,
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
            isStudent: connect.isStudent ?? false,
            company: connect.isStudent ?? false
                ? connect.instituteName ?? ''
                : connect.company ?? '',
            position: connect.isStudent ?? false
                ? connect.degreeProgram ?? ''
                : connect.position ?? '',
            interests: connect.interests ?? [],
            description: connect.description ?? '',
            onSkip: () {
              final provider =
                  Provider.of<SwipeAndConnectProvider>(context, listen: false);
              provider.rejectUser(connect.id);
            },
            onConnect: () {
              final provider =
                  Provider.of<SwipeAndConnectProvider>(context, listen: false);
              provider.makeConnection(connect.id);
            },
            showSecondCard: showSecondCard,
          ),
          Container(
            height: 1.sh,
            width: 1.sw,
            color: color.withOpacity(
              1.0 - opacity,
            ),
          ),
        ],
      ),
    );
  }
}
