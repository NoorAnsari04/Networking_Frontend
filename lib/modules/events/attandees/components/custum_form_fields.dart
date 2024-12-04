import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:my_test_app_flavors/core/extensions/extension.dart';

class CustomFormField extends StatelessWidget {
  final String label;
  final Widget? icon;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool readOnly;

  const CustomFormField({
    Key? key,
    required this.label,
    this.icon,
    required this.controller,
    this.validator,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            if (icon != null) icon!,
            if (icon != null) SizedBox(width: 8.w),
            Text(label),
          ],
        ),
        10.height,
        TextFormField(
          controller: controller,
          decoration: InputDecoration(),
          validator: validator,
          readOnly: readOnly,
        ),
      ],
    );
  }
}
