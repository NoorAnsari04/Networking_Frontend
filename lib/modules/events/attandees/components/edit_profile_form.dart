import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:my_test_app_flavors/core/constants/icon_constants.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';
import 'package:my_test_app_flavors/core/services/validator.dart';
import 'package:my_test_app_flavors/core/shared/custom_elevated_button.dart';
import '../components/custum_form_fields.dart';

class EditProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController linkedinController;
  final TextEditingController descriptionController;

  // Industry person fields
  final TextEditingController? companyController;
  final TextEditingController? positionController;
  final TextEditingController? experienceController;

  // Student fields
  final TextEditingController? degreeProgramController;
  final TextEditingController? yearOfGraduationController;
  final TextEditingController? instituteNameController;

  final bool isStudent;
  final VoidCallback onUpdateProfile;

  const EditProfileForm({
    Key? key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.linkedinController,
    required this.descriptionController,
    required this.isStudent,
    required this.onUpdateProfile,
    this.companyController,
    this.positionController,
    this.experienceController,
    this.degreeProgramController,
    this.yearOfGraduationController,
    this.instituteNameController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          CustomFormField(
            label: 'Name',
            icon: Icon(Icons.person_outline),
            controller: nameController,
          ),
          16.height,
          CustomFormField(
            label: 'Email',
            icon: Icon(Icons.email_outlined),
            controller: emailController,
            validator: Validator.validateEmail,
          ),
          16.height,
          if (isStudent) ...[
            CustomFormField(
              label: 'Degree Program',
              icon: Icon(Icons.school),
              controller: degreeProgramController!,
            ),
            16.height,
            CustomFormField(
              label: 'Year of Graduation',
              icon: Icon(Icons.calendar_today),
              controller: yearOfGraduationController!,
            ),
            16.height,
            CustomFormField(
              label: 'Institute Name',
              icon: SvgPicture.asset(
                IconConstants.universityIcon,
              ),
              controller: instituteNameController!,
            ),
          ] else ...[
            CustomFormField(
              label: 'Company',
              icon: Icon(Icons.business),
              controller: companyController!,
            ),
            16.height,
            CustomFormField(
              label: 'Position',
              icon: SvgPicture.asset(IconConstants.PositionIcon),
              controller: positionController!,
            ),
            16.height,
            CustomFormField(
              label: 'Years of Experience',
              icon: Icon(Icons.work),
              controller: experienceController!,
            ),
          ],
          16.height,
          CustomFormField(
            label: 'Description',
            icon: Icon(Icons.description),
            controller: descriptionController,
          ),
          16.height,
          CustomFormField(
            label: 'LinkedIn URL',
            icon: SvgPicture.asset(IconConstants.linkedinIcon),
            controller: linkedinController,
          ),
          25.height,
          CustomElevatedButton(
            onPressed: onUpdateProfile,
            text: 'Update Profile',
            manualAction: true,
          ),
        ],
      ),
    );
  }
}
