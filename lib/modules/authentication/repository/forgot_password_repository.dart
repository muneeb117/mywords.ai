import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mywords/constants/api_endpoints.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/core/exceptions/error_handler.dart';
import 'package:mywords/core/network/dio_client.dart';

class ForgotPasswordRepository {
  final DioClient _dioClient;

  ForgotPasswordRepository(this._dioClient);

  Future<Either<ApiError, String>> submitEmail(String email) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );

      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        return Right("OTP sent successfully");
      }

      return Left(ApiError(
        errorMsg: 'Unable to send OTP. Please try again.',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'Submit Email');
    }
  }

  Future<Either<ApiError, String>> verifyOtp(String email, String otp) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email, 'otp': otp},
      );

      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        return Right("OTP verified");
      }

      return Left(ApiError(
        errorMsg: 'Invalid or expired OTP',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'Verify OTP');
    }
  }

  Future<Either<ApiError, String>> resetPassword(String email, String otp, String newPassword) async {
    try {
      final response = await _dioClient.post(
        ApiEndpoints.forgotPassword,
        data: {
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        },
      );

      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        return Right("Password reset successfully");
      }

      return Left(ApiError(
        errorMsg: 'Unable to reset password. Please try again.',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'Reset Password');
    }
  }
}
