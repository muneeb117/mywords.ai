import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mywords/constants/api_endpoints.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/core/exceptions/error_handler.dart';
import 'package:mywords/core/network/dio_client.dart';

class AuthRepository {
  final DioClient _dioClient;
  final GoogleSignIn _googleSignIn;

  AuthRepository({required DioClient dioClient, GoogleSignIn? googleSignIn})
    : _dioClient = dioClient,
      _googleSignIn = googleSignIn ?? GoogleSignIn.standard();

  Future<Either<ApiError, String>> login(String email, String password) async {
    try {
      final response = await _dioClient.post(ApiEndpoints.login, data: {'email': email, 'password': password});
      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) && response.data?['token'] != null) {
        final token = response.data['token'];
        _dioClient.setToken(token);
        return Right(token);
      }
      return Left(ApiError(errorMsg: 'Server Error, Please try again', code: response.statusCode ?? 0));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'Login');
    }
  }

  Future<Either<ApiError, String>> signup(String fullName, String email, String password, String provider) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.signup,
        data: {'name': fullName, 'email': email, 'password': password, 'provider': provider},
      );
      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        if (provider == 'google') {
          _dioClient.setToken(response.data['token']);
          return Right(response.data['token']);
        } else {
          return Right(response.data['userId'].toString());
        }
      }
      return Left(ApiError(errorMsg: 'Server Error, Please try again', code: response.statusCode ?? 0));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError(e, stackTrace, context: 'Signup');
    }
  }
}
