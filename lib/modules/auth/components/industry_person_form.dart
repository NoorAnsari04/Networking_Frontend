import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/auth/components/form_data.dart';
import 'custom_userdetails_fields.dart';

class IndustryPersonForm extends StatelessWidget {
  final FormData formData;

  IndustryPersonForm({required this.formData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Company'),
        CustomUserDetailsField(
          controller: formData.companyController,
        ),
        SizedBox(height: 10),
        Text('Years of Experience'),
        CustomUserDetailsField(
          controller: formData.experienceController,
          keyboardType: TextInputType.number,
        ),
        SizedBox(height: 10),
        Text('Designation'),
        CustomUserDetailsField(
          controller: formData.positionController,
        ),
      ],
    );
  }
}
