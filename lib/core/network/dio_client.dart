
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mywords/config/flavors/flavors.dart';

class DioClient extends DioForNative {
  Flavors _flavors;

  String? _authToken;

  void setToken(String token) {
    this._authToken = token;
    log('Token set :: $token');
  }

  void clearToken() {
    this._authToken = null;
  }

  DioClient({required Flavors flavors}) : _flavors = flavors {
    options = BaseOptions(
      baseUrl: _flavors.config.baseUrl,
      responseType: ResponseType.json,
    );

    if (_flavors.config.isDebug) {
      interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        request: false,
        requestHeader: false
      ));
    }

    interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) {
        if (_authToken != null && _authToken != '') {
          options.headers.putIfAbsent('Authorization', () => 'Bearer $_authToken');
        }
        return handler.next(options);
      }),
    );
  }
}
