import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mywords/config/flavors/flavors.dart';

class DioClient extends DioForNative {
  final Flavors _flavors;
  String? _authToken;

  DioClient({required Flavors flavors}) : _flavors = flavors {
    options = BaseOptions(
      baseUrl: _flavors.config.baseUrl,
      responseType: ResponseType.json,
    );

    if (_flavors.config.isDebug) {
      interceptors.add(LogInterceptor(requestBody: true, responseBody: true, responseHeader: false, request: false, requestHeader: true));
    }

    interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authToken != null && _authToken!.isNotEmpty) {
            options.headers.putIfAbsent('Authorization', () => 'Bearer $_authToken');
            log('Adding token to request: $_authToken');
          } else {
            log('No token available for request to: ${options.path}');
          }
          return handler.next(options);
        },
        onError: (DioException e, handler) {
          log('DioError: ${e.message} for ${e.requestOptions.path}');
          return handler.next(e);
        },
      ),
    );
  }

  void setToken(String token) {
    _authToken = token;
    log('Token set in DioClient: $token');
  }

  void clearToken() {
    _authToken = null;
    log('Token cleared in DioClient');
  }

  String? getToken() => _authToken;
}
