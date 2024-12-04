import 'package:flutter/material.dart';

extension SnackBarExtension on BuildContext {
  void showSnackBar(String message) {
    // Remove any existing SnackBars
    ScaffoldMessenger.of(this).removeCurrentSnackBar();

    // Show the new SnackBar
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
}
