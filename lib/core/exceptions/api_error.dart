import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mywords/utils/logger/logger.dart';

class ApiError implements Exception {
  final int? code;
  final String? errorMsg;

  ApiError({
    this.code,
    required this.errorMsg,
  });

  factory ApiError.fromDioException(DioException dioException) {
    print('dio exception is :: ${dioException}');
    final _log = logger(ApiError);
    if (dioException.response != null) {
      log('ApiError.fromDioException: ${dioException.response}');
      switch (dioException.response?.statusCode) {
        case 400:
          return ApiError(
            code: dioException.response?.statusCode,
            errorMsg: dioException.response?.data['error'],
          );
        case 401:
          return ApiError(
            code: dioException.response?.statusCode,
            errorMsg: dioException.response?.data['error'],
          );
        case 404:
          return ApiError(
            code: dioException.response?.statusCode,
            errorMsg: dioException.response?.data['error'],
          );
        case 405:
          return ApiError(
            code: dioException.response?.statusCode,
            errorMsg: dioException.response?.data['error'],
          );
        case 500:
          return ApiError(
            code: dioException.response?.statusCode,
            errorMsg: dioException.response?.data['error'],
          );
        case 503:
          return ApiError(
            code: dioException.response?.statusCode,
            errorMsg: dioException.response?.data['error'],
          );
        default:
          return ApiError(
            code: dioException.response?.statusCode ?? 0,
            errorMsg: dioException.response?.data['error'],
          );
      }
    } else if (dioException.type == DioExceptionType.connectionError) {
      return ApiError(
        code: dioException.response?.statusCode,
        errorMsg: 'Check your connection and try again.',
      );
    }

    /// Exception on socket/no internet
    else if (dioException.type == DioExceptionType.unknown && dioException.error is SocketException) {
      return ApiError(
        code: dioException.response?.statusCode,
        errorMsg: 'Check your connection and try again.',
      );
    }

    /// Exceptions on timeout
    else if (dioException.type == DioExceptionType.connectionTimeout ||
        dioException.type == DioExceptionType.sendTimeout ||
        dioException.type == DioExceptionType.receiveTimeout) {
      return ApiError(
        code: 0,
        errorMsg: 'Connection timeout, Please try again',
      );
    }

    return ApiError(
      code: dioException.response?.statusCode ?? 0,
      errorMsg: dioException.message,
    );
  }

  @override
  String toString() {
    return 'ApiError(code: $code, error: $errorMsg)';
  }
}
