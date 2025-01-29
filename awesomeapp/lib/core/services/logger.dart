import 'package:flutter/material.dart';

class Logger {
  static void logInfo(Object? object) {
    _log(object, Colors.blue, 'INFO');
  }

  static void logSuccess(Object? object) {
    _log(object, Colors.green, 'SUCCESS');
  }

  static void logError(Object? object) {
    _log(object, Colors.red, 'ERROR');
  }

  static void logWarning(Object? object) {
    _log(object, Colors.yellow, 'Warning');
  }

  static void log(Object? object, {Color? color, String? level}) {
    _log(object, color ?? Colors.white70, level ?? 'MESSAGE');
  }

  static void _log(Object? object, Color color, String level) {
    debugPrint('\x1B[38;2;${color.red};${color.green};${color.blue}m[$level] $object\x1B[0m');
  }
}
