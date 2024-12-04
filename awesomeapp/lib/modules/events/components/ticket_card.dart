import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';
import 'package:my_test_app_flavors/core/constants/font_constants.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/shared/user_avatar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../auth/services/app_user.dart';
import '../services/event_model.dart';

class TicketCard extends StatelessWidget {
  final AppUser appUser;
  final EventModel eventModel;

  const TicketCard({
    Key? key,
    required this.appUser,
    required this.eventModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          child: Card(
            child: Column(
              children: [
                _buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      20.height,
                      _buildInfoRow(),
                      20.height,
                      _buildQRCode(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        _buildAvatar(context),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 130,
      color: ColorConstants.primaryColor,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Column(
            children: [
              20.height,
              Text('${appUser.name}', style: kRaleway),
              Text(appUser.position ?? '',
                  style: kRaleway.copyWith(fontSize: 16.sp)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildInfoColumn(
            'Venue:', eventModel.venue, 'Start Date:', eventModel.startDate),
        _buildInfoColumn(
            'Time:', eventModel.time, 'End Date:', eventModel.endDate),
      ],
    );
  }

  Widget _buildInfoColumn(
      String label1, String value1, String label2, String value2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label1, style: ticketlabel),
        Text(value1, style: ticketText),
        SizedBox(height: 10),
        Text(label2, style: ticketlabel),
        Text(value2, style: ticketText),
      ],
    );
  }

  Widget _buildQRCode() {
    return QrImageView(
      data: 'This is a simple QR code',
      version: QrVersions.auto,
      size: 220,
      gapless: false,
    );
  }

  Widget _buildAvatar(BuildContext context) {
    return Positioned(
      top: -40,
      left: MediaQuery.of(context).size.width / 2 - 60,
      child: UserProfileAvatar(
        imageUrl: appUser.imageUrl,
        outerRadius: 46.w,
        innerRadius: 40.w,
      ),
    );
  }
}
