import 'package:flutter/material.dart';

class UserTypeSelection extends StatelessWidget {
  final bool isStudent;
  final ValueChanged<bool?> onChanged;
  final String title;

  UserTypeSelection({
    required this.isStudent,
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
          value: true,
          groupValue: isStudent,
          onChanged: onChanged,
        ),
        RadioListTile(
          title: Text('Industry Person'),
          value: false,
          groupValue: isStudent,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
