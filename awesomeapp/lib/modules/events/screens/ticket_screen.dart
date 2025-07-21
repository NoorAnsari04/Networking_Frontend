import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:my_test_app_flavors/core/constants/icon_constants.dart';
import 'package:my_test_app_flavors/core/shared/custum_appbar.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import '../../auth/services/app_user.dart';
import '../services/event_model.dart';
import '../services/event_provider.dart';
import '../components/ticket_card.dart';
import '../ticket/services/ticket_provider.dart';

// class TicketScreen extends StatelessWidget {
//   static const id = 'tickets';
//   final AppUser appUser;
//   final EventModel eventModel;
//
//   TicketScreen({required this.appUser, required this.eventModel, Map<String, dynamic>? ticketDetails});
//
//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider(
//       create: (_) => EventProvider(),
//       child: Scaffold(
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 CustomAppBar(
//                   title: 'Ticket',
//                   iconPath: IconConstants.arrowIcon,
//                 ),
//                 80.height,
//                 TicketCard(appUser: appUser, eventModel: eventModel),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
class TicketScreen extends StatefulWidget {
  static const id = 'tickets';
  final AppUser appUser;
  final EventModel eventModel;

  TicketScreen({
    required this.appUser,
    required this.eventModel,
    Map<String, dynamic>? ticketDetails,
  });

  @override
  State<TicketScreen> createState() => _TicketScreenState();
}

class _TicketScreenState extends State<TicketScreen> {
  late TicketProvider ticketProvider;

  @override
  void initState() {
    super.initState();
    ticketProvider = TicketProvider();
    ticketProvider.fetchTicketDetails(widget.eventModel.eventId ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TicketProvider>.value(
      value: ticketProvider,
      child: Scaffold(
        body: Consumer<TicketProvider>(
          builder: (context, provider, _) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.errorMessage != null) {
              return Center(child: Text(provider.errorMessage!));
            }

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    CustomAppBar(
                      title: 'Ticket',
                      iconPath: IconConstants.arrowIcon,
                    ),
                    80.height,
                    TicketCard(
                      appUser: widget.appUser,
                      eventModel: widget.eventModel,
                      ticketDetails: provider.ticketDetails,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
