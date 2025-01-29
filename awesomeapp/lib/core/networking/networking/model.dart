import 'dart:io';

import 'package:dio/dio.dart';

import 'network_constants.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ApiResponseGeneric {
  int? code;
  bool success;
  String? type;
  Map<String, dynamic> body;
  String? message, shortMessage;

  ApiResponseGeneric({
    this.code,
    this.type,
    this.message,
    this.shortMessage,
    this.body = const {},
  }) : success = (code == 200 || code == 201);

  factory ApiResponseGeneric.fromResponse(Response response) {
    return ApiResponseGeneric(
      code: response.statusCode,
      body: response.data['data'] ?? {},
      message: response.data['message'],
    );
  }

  void showMessage({bool onSuccess = false}) {
    if ((!success || onSuccess) && message != null) {
      // AppToast.show(
      //   message!,
      //   type: success ? AppToastType.success : AppToastType.error,
      // );
      Fluttertoast.showToast(msg: message ?? "unkonwn message");
    }
  }
  
}

class CustomException implements Exception {
  String? message;
  String? shortMessage;

  CustomException({
    this.message = "",
    this.shortMessage = "",
  });

  factory CustomException.fromApiResponseGeneric(ApiResponseGeneric response) {
    return CustomException(
      message: response.message,
      shortMessage: response.shortMessage,
    );
  }
}

// ignore: constant_identifier_names
enum RequestType { GET, PUT, POST, PATCH }

class RequestMedium {
  static String get currentMedium =>
      Platform.isAndroid ? NetworkConstants.platformAndroid : NetworkConstants.platformIOS;
}
