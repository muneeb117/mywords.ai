import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mywords/constants/api_endpoints.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/core/exceptions/error_handler.dart';
import 'package:mywords/core/network/dio_client.dart';

class SettingsRepository {
  final DioClient _dioClient;

  SettingsRepository({required DioClient dioClient}) : _dioClient = dioClient;

  Future<Either<ApiError, String>> deleteAccount() async {
    /// remove this line
    return Right("Account deleted successfully");
    try {
      final response = await _dioClient.post(
        ApiEndpoints.deleteAccount,
      );
      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        return Right("Account deleted successfully");
      }
      return Left(ApiError(
        errorMsg: 'Unable to delete Account. Please try again.',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'Delete Account');
    }
  }
}
