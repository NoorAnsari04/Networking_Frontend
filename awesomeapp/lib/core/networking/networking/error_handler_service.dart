import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';

// import '../services/logger.dart';
import '../../services/logger.dart';
import 'model.dart';

class CustomExceptionHandler {
  ApiResponseGeneric handleException(dynamic e) {
    if (e is FileSystemException) {
      return _handleFileSystemException(e);
    } else if (e is PlatformException) {
      return _handlePlatformException(e);
    } else if (e is CustomException) {
      return _handleMyException(e);
    } else if (e is SocketException) {
      return _handleSocketException(e);
    } else if (e is TimeoutException) {
      return _handleTimeoutException(e);
    } else if (e is DioException) {
      return _handleDioError(e);
    } else if (e is TypeError) {
      return _handleTypeError(e);
    } else {
      return _genericErrorResponse();
    }
  }

  ApiResponseGeneric _handleTypeError(dynamic typeError) {
    return ApiResponseGeneric(
      code: 400,
      shortMessage: "Type Error",
      message: typeError.toString(),
    );
  }

  ApiResponseGeneric _handleDioError(DioException e) {
    Logger.logError('Dio error: ${e.error.runtimeType}');
    Logger.logError('Dio error type: ${e.type}');
    Logger.logError('Response: ${e.response}');

    if (e.error is SocketException) {
      return _handleSocketException(e.error as SocketException);
    } else if (e.error is TypeError) {
      return _handleTypeError(e);
    } else if (e.error is HttpException) {
      return _handleHttpException(e.error as HttpException);
    }

    if (e.type == DioExceptionType.badResponse) {
      return _buildApiResponseGeneric(
        data: e.response?.data['data'],
        code: e.response?.statusCode ?? 400,
        message: e.response?.data['message'] ?? 'Error Occurred',
      );
    } else {
      return _genericErrorResponse();
    }
  }

  ApiResponseGeneric _handleFileSystemException(FileSystemException e) {
    return _buildApiResponseGeneric(
      code: 400,
      message: "File System Error: ${e.message}.",
    );
  }

  ApiResponseGeneric _handlePlatformException(PlatformException e) {
    return _buildApiResponseGeneric(
      code: 400,
      message: "Platform Error: ${e.message}.",
    );
  }

  ApiResponseGeneric _handleMyException(CustomException e) {
    return _buildApiResponseGeneric(
      code: 400,
      message: e.message ?? "An error occurred.",
      shortMessage: e.shortMessage ?? "Error Occurred",
    );
  }

  ApiResponseGeneric _handleSocketException(SocketException e) {
    return _buildApiResponseGeneric(
      code: 404,
      type: ErrorType.connectivity,
      message: "Please check your internet connection.",
    );
  }

  ApiResponseGeneric _handleHttpException(HttpException e) {
    return _buildApiResponseGeneric(
      code: 404,
      type: ErrorType.connectivity,
      shortMessage: "Error Occurred",
      message: "Please check your internet connection.",
    );
  }

  ApiResponseGeneric _handleTimeoutException(TimeoutException e) {
    return _buildApiResponseGeneric(
      code: 404,
      type: ErrorType.timeout,
      message: "Your request has timed out.",
    );
  }

  // new practices //

  ApiResponseGeneric _buildApiResponseGeneric({
    String? shortMessage,
    String? message,
    String? type,
    int? code,
    dynamic data,
  }) {
    return ApiResponseGeneric(
      shortMessage: shortMessage ?? "Error Occurred",
      message: message ?? "Something went wrong.",
      body: data ?? {},
      type: type,
      code: code,
    );
  }

  ApiResponseGeneric _genericErrorResponse() {
    return ApiResponseGeneric(
      code: 400,
      shortMessage: "Error Occurred",
      message: "Something went wrong. Please try again later.",
    );
  }
}

class ErrorType {
  static const String connectivity = "connectivity";
  static const String timeout = "timeout";
}
