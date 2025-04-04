import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mywords/config/flavors/flavors.dart';

class DioClient extends DioForNative {
  Flavors _flavors;

  String? _authToken;

  void setToken(String token) {
    this._authToken = token;
  }

  DioClient({required Flavors flavors}) : _flavors = flavors {
    options = BaseOptions(
      baseUrl: _flavors.config.baseUrl,
      responseType: ResponseType.json,
    );
    interceptors.add(
      InterceptorsWrapper(onRequest: (options, handler) {
        if (_authToken != null) {
          options.headers.putIfAbsent('Authorization', () => 'Bearer $_authToken');
        }
        return handler.next(options);
      }),
    );
  }
}
