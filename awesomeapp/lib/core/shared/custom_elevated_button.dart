import 'package:flutter/material.dart';
import 'package:my_test_app_flavors/core/constants/color_constants.dart';

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Widget? icon;
  final bool manualAction;
  final double? width;
  final double? height;

  CustomElevatedButton({
    required this.onPressed,
    required this.text,
    this.icon,
    this.manualAction = false,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon ?? Container(),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        foregroundColor: manualAction ? Colors.white : Colors.black, backgroundColor: manualAction ? ColorConstants.primaryColor : Colors.white,
        minimumSize: Size(width ?? double.infinity, height ?? 45),
        side: manualAction
            ? BorderSide.none
            : BorderSide(color: ColorConstants.borderColor),
      ),
    );
  }
}
