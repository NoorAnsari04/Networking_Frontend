import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/constants/font_constants.dart';
import '../auth/services/app_user.dart';
import '../screens/connected_profile.dart';

class ConnectionTile extends StatelessWidget {
  final AppUser user;

  ConnectionTile({
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final bool isStudent = user.isStudent ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConnectedProfiles(user: user),
          ),
        );
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: user.imageUrl != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.imageUrl!),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                  title: Text(
                    user.fullName,
                    style: bodyMediumTextStyle,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          isStudent
                              ? user.degreeProgram ?? ''
                              : user.position ?? '',
                          style: smallTextStyle),
                      Text(
                        isStudent
                            ? user.instituteName ?? ''
                            : user.company ?? '',
                        style: smallTextStyle.copyWith(
                            fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
