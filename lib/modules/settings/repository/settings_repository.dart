import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:mywords/constants/api_endpoints.dart';
import 'package:mywords/core/exceptions/api_error.dart';
import 'package:mywords/core/exceptions/error_handler.dart';
import 'package:mywords/core/network/dio_client.dart';

class SettingsRepository {
  final DioClient _dioClient;

  SettingsRepository({required DioClient dioClient}) : _dioClient = dioClient;

  Future<Either<ApiError, String>> changePassword(String password, String newPassword) async {
    // remove this line
    await Future.delayed(Duration(seconds: 3));
    return Right("Password changed successfully");
    try {
      final response = await _dioClient.post(
        ApiEndpoints.changePassword,
        data: {'password': password, 'newPassword': newPassword},
      );
      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        return Right("Password changed successfully");
      }
      return Left(ApiError(
        errorMsg: 'Unable to change Password. Please try again.',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError<String>(e, stackTrace, context: 'Change Password');
    }
  }

  Future<Either<ApiError, String>> deleteAccount() async {
    try {
      final response = await _dioClient.delete(
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

  Future<Either<ApiError, ({String name, String email})>> getProfile() async {
    /// remove this line
    // await Future.delayed(Duration(seconds: 3));
    // return Right("Profile fetched successfully");
    try {
      final response = await _dioClient.get(
        ApiEndpoints.getProfile,
      );
      if ((response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created)) {
        return Right((name: response.data['name'], email: response.data['email']));
      }
      return Left(ApiError(
        errorMsg: 'Unable to get Profile. Please try again.',
        code: response.statusCode ?? 0,
      ));
    } catch (e, stackTrace) {
      return ErrorHandler.handleError(e, stackTrace, context: 'Get Profile');
    }
  }
}
