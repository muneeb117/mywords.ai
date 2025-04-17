import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mywords/constants/api_endpoints.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/core/exceptions/error_handler.dart';
import 'package:mywords/core/network/dio_client.dart';

class AiDetectorRepository {
  final DioClient _dioClient;

  AiDetectorRepository({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  Future<Either<ApiError, String>> detect({required Map<String, dynamic> data}) async {
    final token = _dioClient.getToken();
    log('Token before API call: $token');
    try {
      final response = await _dioClient.post(ApiEndpoints.aiDetector, data: data);

      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        return Right(response.data['generatedText']);
      }
      return Left(ApiError(
        errorMsg: 'Server Error, Please try again',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'AI Writer');
    }
  }
}
