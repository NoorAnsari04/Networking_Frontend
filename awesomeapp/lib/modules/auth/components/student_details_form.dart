import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/auth/components/form_data.dart';
import 'custom_userdetails_fields.dart'; // Assuming the user details field is used for text input

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
          // hintText: 'Enter your degree program',
          onChanged: (_){},
        ),
        SizedBox(height: 10),
        Text('Year of Graduation'),
        CustomUserDetailsField(
          controller: formData.graduationYearController,
          // hintText: 'Enter your year of graduation',
          onChanged: (value) {
            formData.selectedYear = value;  
          },
        ),
        SizedBox(height: 10),
        Text('Institute Name'),
        CustomUserDetailsField(
          controller: formData.instituteNameController,
          // hintText: 'Enter your institute name',
          onChanged: (value) {
            formData.selectedInstitute = value;  
          },
        ),
      ],
    );
  }
}
