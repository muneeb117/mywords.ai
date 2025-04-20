import 'dart:developer';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mywords/constants/api_endpoints.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/core/exceptions/error_handler.dart';
import 'package:mywords/core/network/dio_client.dart';

class HomeRepository {
  final DioClient _dioClient;

  HomeRepository({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  Future<Either<ApiError, int>> getDocumentsCount() async {
    final token = _dioClient.getToken();
    log('Token before API call: $token');
    try {
      final response = await _dioClient.get(
        ApiEndpoints.savePromptData,
        queryParameters: {'type': 'file'},
      );

      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        int numberOfDocs = 20;
        return Right(numberOfDocs);
      }
      return Left(ApiError(
        errorMsg: 'Server Error, Please try again',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError(e, stackTrace, context: 'Save Writer Prompt');
    }
  }
}
