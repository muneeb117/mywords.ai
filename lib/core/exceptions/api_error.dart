import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mywords/utils/logger/logger.dart';

class ApiError implements Exception {
  final int? code;
  final String? message;

  ApiError({
    this.code,
    required this.message,
  });

  factory ApiError.fromDioException(DioException dioException) {
    final _log = logger(ApiError);
    if (dioException.response != null) {
      _log.e('ApiError.fromDioException: ${dioException.response?.data}');
      switch (dioException.response?.statusCode) {
        case 401:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        case 404:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        case 405:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        case 500:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        case 503:
          return ApiError(
            code: dioException.response?.statusCode,
            message: dioException.response?.data['message'],
          );
        default:
          return ApiError(
            code: dioException.response?.statusCode ?? 0,
            message: dioException.response?.data['message'],
          );
      }
    }

    /// Exception on socket/no internet
    else if (dioException.type == DioExceptionType.unknown && dioException.error is SocketException) {
      return ApiError(
        code: dioException.response?.statusCode,
        message: dioException.response?.statusMessage,
      );
    }

    /// Exceptions on timeout
    else if (dioException.type == DioExceptionType.connectionTimeout ||
        dioException.type == DioExceptionType.sendTimeout ||
        dioException.type == DioExceptionType.receiveTimeout) {
      return ApiError(
        code: 0,
        message: 'Connection timeout, Please try again',
      );
    }

    return ApiError(
      code: dioException.response?.statusCode ?? 0,
      message: dioException.message,
    );
  }

  @override
  String toString() {
    return 'ApiError(code: $code, message: $message)';
  }
}
