import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/auth/components/form_data.dart';
import 'custom_dropDown.dart';
import 'custom_userdetails_fields.dart';

class StudentDetailsForm extends StatelessWidget {
  final FormData formData;

  StudentDetailsForm({required this.formData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Degree Program'),
        CustomUserDetailsField(
          controller: formData.degreeProgramController,
        ),
        SizedBox(height: 10),
        Text('Year of Graduation'),
        CustomDropdown(
          items: formData.years,
          onChanged: (value) => formData.selectedYear = value,
        ),
        SizedBox(height: 10),
        Text('Institute Name'),
        CustomDropdown(
          items: formData.institutes,
          onChanged: (value) => formData.selectedInstitute = value,
        ),
      ],
    );
  }
}
