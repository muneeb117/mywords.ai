import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/utils/logger/logger.dart';

class ErrorHandler {
  static Left<ApiError, T> handleError<T>(
    Object e,
    StackTrace stackTrace, {
    String context = 'API Call',
  }) {
    final fullContext = context == 'API Call' ? context : '$context - API Call';

    final _log = logger(ErrorHandler);
    if (e is DioException) {
      _log.e('$fullContext failed', error: e, stackTrace: stackTrace);
      return Left(ApiError.fromDioException(e));
    } else if (e is TypeError) {
      _log.e('TypeError during of $fullContext', error: e, stackTrace: e.stackTrace);
      return Left(ApiError(errorMsg: '$e', code: 0));
    } else {
      _log.e('Unknown error during of $fullContext', error: e, stackTrace: stackTrace);
      return Left(ApiError(errorMsg: '$e', code: 0));
    }
  }
}
