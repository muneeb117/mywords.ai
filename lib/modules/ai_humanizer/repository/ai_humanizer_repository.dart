import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mywords/constants/api_endpoints.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/core/exceptions/error_handler.dart';
import 'package:mywords/core/network/dio_client.dart';

class AiHumanizerRepository {
  final DioClient _dioClient;

  AiHumanizerRepository({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  Future<Either<ApiError, String>> humanize({required Map<String, dynamic> data}) async {
    final token = _dioClient.getToken();
    log('Token before API call: $token');
    try {
      final response = await _dioClient.post(ApiEndpoints.aiHumanize, data: data);

      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        return Right(response.data['humanizedText']);
      }
      return Left(ApiError(
        errorMsg: 'Server Error, Please try again',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'AI Writer');
    }
  }

  Future<Either<ApiError, String>> saveHumanizerPromptData({required Map<String, dynamic> data}) async {
    final token = _dioClient.getToken();
    log('Token before API call: $token');
    try {
      final response = await _dioClient.post(ApiEndpoints.savePromptData, data: data);

      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        return Right('Saved user prompt');
      }
      return Left(ApiError(
        errorMsg: 'Server Error, Please try again',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'Save Humanizer Prompt');
    }
  }
}
