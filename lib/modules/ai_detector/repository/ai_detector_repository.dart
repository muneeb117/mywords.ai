import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mywords/constants/api_endpoints.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/core/exceptions/error_handler.dart';
import 'package:mywords/core/network/dio_client.dart';
import 'package:mywords/modules/ai_detector/models/ai_detector_entity.dart';
import 'package:mywords/modules/ai_detector/models/ai_detector_result.dart';

class AiDetectorRepository {
  final DioClient _dioClient;

  AiDetectorRepository({required DioClient dioClient}) : _dioClient = dioClient;

  Future<Either<ApiError, AiDetectorEntity>> detect({required Map<String, dynamic> data}) async {
    final token = _dioClient.getToken();
    log('Token before API call: $token');
    try {
      final response = await _dioClient.post(ApiEndpoints.aiDetector, data: data);

      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        AiDetectionResult aiDetectionResult = AiDetectionResult.fromJson(response.data);
        AiDetectorEntity aiDetectorEntity = AiDetectorEntity.fromModel(aiDetectionResult);
        return Right(aiDetectorEntity);
      }
      return Left(ApiError(errorMsg: 'Server Error, Please try again', code: response.statusCode ?? 0));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError(e, stackTrace, context: 'AI Detector');
    }
  }
}
