import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_test_app_flavors/core/constants/icon_constants.dart';
import 'package:my_test_app_flavors/core/shared/custum_appbar.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import '../../auth/services/app_user.dart';
import '../services/event_model.dart';
import '../services/event_provider.dart';
import '../components/ticket_card.dart';

class TicketScreen extends StatelessWidget {
  static const id = 'tickets';
  final AppUser appUser;
  final EventModel eventModel;

  TicketScreen({required this.appUser, required this.eventModel});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventProvider(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomAppBar(
                  title: 'Ticket',
                  iconPath: IconConstants.arrowIcon,
                ),
                80.height,
                TicketCard(appUser: appUser, eventModel: eventModel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
