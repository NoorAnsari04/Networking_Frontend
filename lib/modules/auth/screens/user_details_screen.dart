import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/auth/components/form_data.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/icon_constants.dart';
import '../../../core/shared/custom_elevated_button.dart';
import '../../../core/shared/custum_appbar.dart';
import '../components/comman_details_form.dart';
import '../components/industry_person_form.dart';
import '../components/student_details_form.dart';
import '../components/user_type_selection.dart';
import '../services/submit_form.dart';

class UserDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> signupData;
  final bool isGoogleSignIn;

  const UserDetailsScreen({
    Key? key,
    required this.signupData,
    this.isGoogleSignIn = false,
  }) : super(key: key);

  static const id = 'details';

  @override
  _UserDetailsScreenState createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  bool isStudent = true;
  final _formKey = GlobalKey<FormState>();
  final formData = FormData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: _buildFormContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(
        color: ColorConstants.primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10.0)),
      ),
      child: CustomAppBar(
        title: 'User Details',
        iconPath: IconConstants.backward_arrow,
        titleColor: Colors.white,
      ),
    );
  }

  Widget _buildFormContent() {
    return ListView(
      children: [
        UserTypeSelection(
          isStudent: isStudent,
          onChanged: (value) {
            setState(() {
              isStudent = value!;
            });
          },
          title: 'Who are you?',
        ),
        SizedBox(height: 10),
        if (isStudent)
          StudentDetailsForm(formData: formData)
        else
          IndustryPersonForm(formData: formData),
        SizedBox(height: 10),
        CommonDetailsForm(formData: formData),
        SizedBox(height: 10),
        CustomElevatedButton(
          manualAction: true,
          onPressed: () => submitForm(
            context,
            _formKey,
            formData,
            widget.signupData,
            isGoogleSignIn: widget.isGoogleSignIn,
          ),
          text: 'Submit',
        ),
      ],
    );
  }
}
