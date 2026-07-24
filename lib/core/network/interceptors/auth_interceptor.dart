import 'package:dio/dio.dart';

import '../../session/session_manager.dart';

class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionManager);

  final SessionManager _sessionManager;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _sessionManager.accessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
