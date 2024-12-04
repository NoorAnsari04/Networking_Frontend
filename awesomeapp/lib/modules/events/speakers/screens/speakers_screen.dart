import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:my_test_app_flavors/modules/events/speakers/components/speaker_listTile.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/font_constants.dart';
import '../../../../core/constants/icon_constants.dart';
import '../../../../core/shared/custum_appbar.dart';
import '../../../auth/services/app_user.dart';
import '../services/meeting_request_model.dart';
import '../services/speaker_provider.dart';
import 'meeting_request_screen.dart';

class SpeakersScreen extends StatefulWidget {
  static const id = 'speakerScreen';

  @override
  State<SpeakersScreen> createState() => _SpeakersScreenState();
}

class _SpeakersScreenState extends State<SpeakersScreen> {
  TextEditingController _searchController = TextEditingController();
  List<AppUser> _filteredSpeakers = [];
  bool _isCurrentUserSpeaker = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final speakerProvider =
          Provider.of<SpeakerProvider>(context, listen: false);
      await speakerProvider.fetchSpeakers();
      _isCurrentUserSpeaker = await speakerProvider.isCurrentUserSpeaker();
    });

    _searchController.addListener(_filterSpeakers);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterSpeakers);
    _searchController.dispose();
    super.dispose();
  }

  void _filterSpeakers() {
    final query = _searchController.text;
    final speakerProv = Provider.of<SpeakerProvider>(context, listen: false);
    setState(() {
      _filteredSpeakers = List.from(speakerProv.filterSpeakers(query));
    });
  }

  Widget _buildTrailingButton(
      AppUser speaker, SpeakerProvider speakerProvider) {
    // todo use Consumer instead if FutureBuilder and getRequestStatus on init state
    return FutureBuilder<String>(
      future: speakerProvider.getRequestStatus(speaker.id),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        final status = snapshot.data ?? 'none';

        switch (status) {
          case 'pending':
            return ElevatedButton(
              onPressed: null,
              child: Text('Pending'),
            );
          case 'accepted':
            return ElevatedButton(
              onPressed: null,
              child: Text('Accepted'),
            );
          default:
            return ElevatedButton(
              onPressed: () async {
                final currentUserId = speakerProvider.getCurrentUserId() ?? '';

                if (_isCurrentUserSpeaker) {
                  final request = MeetingRequest(
                    senderId: currentUserId,
                    receiverId: speaker.id,
                    status: 'pending',
                    timestamp: DateTime.now(),
                  );
                  await speakerProvider.createMeetingRequest(request);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Connection request sent to ${speaker.fullName}')),
                  );
                } else {
                  context.pushNamed(
                    MeetingRequestScreen.id,
                    extra: {'speaker': speaker},
                  );
                }
              },
              child: Text(_isCurrentUserSpeaker ? 'Connect' : 'Request'),
            );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CustomAppBar(
            title: 'Speakers',
            iconPath: IconConstants.arrowIcon,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: searchInputDecoration,
            ),
          ),
          Expanded(
            child: Consumer<SpeakerProvider>(
              builder: (context, speakerProvider, child) {
                if (speakerProvider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (speakerProvider.speakers.isEmpty) {
                  return Center(child: Text('No speakers found'));
                }
                final speakersToShow =
                    _filteredSpeakers.isEmpty && _searchController.text.isEmpty
                        ? speakerProvider.speakers
                        : _filteredSpeakers;
                return ListView.builder(
                  itemCount: speakersToShow.length,
                  itemBuilder: (context, index) {
                    final speaker = speakersToShow[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 6.h,
                        horizontal: 8.w,
                      ),
                      child: SpeakerListTile(
                        speaker: speaker,
                        speakerProvider: speakerProvider,
                        buildTrailingButton: _buildTrailingButton,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
