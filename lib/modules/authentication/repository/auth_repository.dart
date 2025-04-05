import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mywords/constants/api_endpoints.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/core/exceptions/error_handler.dart';
import 'package:mywords/core/network/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient;

  AuthRepository({
    required DioClient dioClient,
  }) : _dioClient = dioClient;

  Future<Either<ApiError, String>> login(String email, String password) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.login,
        data: {'email': email, 'password': password},
      );
      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) && response.data?['token'] != null) {
        return Right(response.data['token']);
      }
      return Left(ApiError(
        errorMsg: 'Server Error, Please try again',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'Login');
    }
  }

  Future<Either<ApiError, int>> signup(String fullName, String email, String password) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.signup,
        data: {'name': fullName, 'email': email, 'password': password},
      );
      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) && response.data?['userId'] != null) {
        return Right(response.data['userId']);
      }
      return Left(ApiError(
        errorMsg: 'Server Error, Please try again',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<int>(e, stackTrace, context: 'Signup');
    }
  }
}
