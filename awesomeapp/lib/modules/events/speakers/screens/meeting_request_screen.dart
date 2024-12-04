import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';
import 'package:my_test_app_flavors/core/extensions/scaffold_message.dart';
import 'package:my_test_app_flavors/modules/events/speakers/services/speaker_provider.dart';
import 'package:provider/provider.dart';
import '../../../auth/services/app_user.dart';
import '../../../auth/services/auth_provider.dart';
import '../components/meeting_request_form.dart';
import '../services/meeting_request_model.dart';

class MeetingRequestScreen extends StatefulWidget {
  final AppUser speaker;
  final Map<String, dynamic>? requestData;
  final bool isViewOnly;
  static const id = 'form';

  MeetingRequestScreen({
    required this.speaker,
    this.requestData,
    @override this.isViewOnly = false,
  });

  _MeetingRequestScreenState createState() => _MeetingRequestScreenState();
}

class _MeetingRequestScreenState extends State<MeetingRequestScreen> {
  late final AuthenticationProvider _authProvider;
  late final SpeakerProvider _speakerProvider;

  final _formKey = GlobalKey<FormState>();
  late TextEditingController _meetingTitleController;
  late TextEditingController _attendeeNameController;
  late TextEditingController _companyController;
  late TextEditingController _positionController;
  late TextEditingController _universityController;
  late TextEditingController _degreeProgramController;
  late TextEditingController _emailController;

  late bool _isStudentRequest;

  @override
  void initState() {
    super.initState();
    _authProvider = Provider.of<AuthenticationProvider>(context, listen: false);
    _speakerProvider = Provider.of<SpeakerProvider>(context, listen: false);

    _isStudentRequest = widget.isViewOnly
        ? (widget.requestData?['university'] != null ||
            widget.requestData?['degreeProgram'] != null)
        : (_authProvider.appUser!.isStudent ?? false);

    if (widget.requestData != null) {
      _meetingTitleController =
          TextEditingController(text: widget.requestData!['meetingTitle']);
      _attendeeNameController =
          TextEditingController(text: widget.requestData!['attendeeName']);
      _companyController =
          TextEditingController(text: widget.requestData!['company']);
      _positionController =
          TextEditingController(text: widget.requestData!['position']);
      _universityController =
          TextEditingController(text: widget.requestData!['university']);
      _degreeProgramController =
          TextEditingController(text: widget.requestData!['degreeProgram']);
      _emailController =
          TextEditingController(text: widget.requestData!['email']);
    } else {
      _meetingTitleController = TextEditingController();
      _attendeeNameController =
          TextEditingController(text: _authProvider.appUser!.fullName);
      _companyController =
          TextEditingController(text: _authProvider.appUser!.company);
      _positionController =
          TextEditingController(text: _authProvider.appUser?.position);
      _universityController =
          TextEditingController(text: _authProvider.appUser!.instituteName);
      _degreeProgramController =
          TextEditingController(text: _authProvider.appUser!.degreeProgram);
      _emailController =
          TextEditingController(text: _authProvider.appUser!.email);
    }
  }

  @override
  void dispose() {
    _meetingTitleController.dispose();
    _attendeeNameController.dispose();
    _companyController.dispose();
    _positionController.dispose();
    _universityController.dispose();
    _degreeProgramController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final currentUserId = _authProvider.appUser!.id;
        final speakerId = widget.speaker.id;

        final request = MeetingRequest(
          senderId: currentUserId,
          receiverId: speakerId,
          meetingTitle: _meetingTitleController.text,
          attendeeName: _attendeeNameController.text,
          company: _isStudentRequest ? null : _companyController.text,
          position: _isStudentRequest ? null : _positionController.text,
          university: _isStudentRequest ? _universityController.text : null,
          degreeProgram:
              _isStudentRequest ? _degreeProgramController.text : null,
          email: _emailController.text,
        );

        await _speakerProvider.createMeetingRequest(request);

        context.showSnackBar('Meeting request sent successfully!');

        Navigator.of(context).pop();
      } catch (e) {
        context
            .showSnackBar('Failed to send meeting request. Please try again.');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 5,
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                ),
              ),
            ),
            MeetingRequestForm(
              speaker: widget.speaker,
              isViewOnly: widget.isViewOnly,
              isStudentRequest: _isStudentRequest,
              formKey: _formKey,
              meetingTitleController: _meetingTitleController,
              attendeeNameController: _attendeeNameController,
              companyController: _companyController,
              positionController: _positionController,
              universityController: _universityController,
              degreeProgramController: _degreeProgramController,
              emailController: _emailController,
              submitForm: _submitForm,
              requestData: widget.requestData,
            ),
          ],
        ),
      ),
    );
  }
}
