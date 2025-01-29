import 'package:flutter/material.dart';

class UserTypeSelection extends StatelessWidget {
  final String userType;
  final ValueChanged<String?> onChanged;
  final String title;

  UserTypeSelection({
    required this.userType,
    required this.onChanged,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        RadioListTile(
          title: Text('Student'),
          value: 'Student',
          groupValue: userType,
          onChanged: onChanged,
        ),
        RadioListTile(
          title: Text('Industry Person'),
          value: 'Industry Person',
          groupValue: userType,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
