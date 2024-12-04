import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/modules/auth/components/form_data.dart';
import 'custom_userdetails_fields.dart';
import 'interests_selection.dart';

class CommonDetailsForm extends StatelessWidget {
  final FormData formData;

  CommonDetailsForm({required this.formData});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Linkedin URL'),
        CustomUserDetailsField(
          controller: formData.linkedinUrlController,
          keyboardType: TextInputType.url,
        ),
        SizedBox(height: 10),
        Text('Description'),
        CustomUserDetailsField(
          controller: formData.descriptionController,
        ),
        SizedBox(height: 10),
        Card(
          color: Colors.white,
          child: ListTile(
            title: Text('Select Interests'),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => _showInterestSelection(context),
          ),
        ),
      ],
    );
  }

  void _showInterestSelection(BuildContext context) async {
    final selectedInterests = await showModalBottomSheet<List<String>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.5,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: InterestSelection(
            initialInterests: formData.interests,
          ),
        );
      },
    );
    if (selectedInterests != null) {
      formData.interests = selectedInterests;
    }
  }
}
