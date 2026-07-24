import 'package:dio/dio.dart';

import '../../session/session_manager.dart';

/// Anexa o cabeçalho `Authorization: Bearer <accessToken>` e, em respostas
/// 401, tenta renovar o access token via refresh token, reenviando a
/// requisição original. Se o refresh falhar, dispara [onUnauthorized]
/// (tipicamente encerra a sessão e redireciona para o login).
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._sessionManager, this._dio, this._onUnauthorized);

  final SessionManager _sessionManager;
  final Dio _dio;
  final void Function() _onUnauthorized;

  static const _noAuthKey = '_noAuthRetry';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (options.extra[_noAuthKey] == true) {
      handler.next(options);
      return;
    }
    final header = _sessionManager.bearerHeader();
    if (header != null) {
      options.headers['Authorization'] = header;
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final isRefreshAttempt = err.requestOptions.extra[_noAuthKey] == true;
    if (err.response?.statusCode == 401 && !isRefreshAttempt) {
      final refreshToken = _sessionManager.refreshToken;
      if (refreshToken != null && refreshToken.isNotEmpty) {
        try {
          final response = await _dio.post<Map<String, dynamic>>(
            '/api/v1/auth/refresh',
            data: {'refreshToken': refreshToken},
            options: Options(extra: {_noAuthKey: true}),
          );
          final data = response.data?['data'] as Map<String, dynamic>?;
          final newAccessToken = data?['accessToken'] as String?;
          if (newAccessToken != null && newAccessToken.isNotEmpty) {
            await _sessionManager.updateAccessToken(newAccessToken);
            final retry = await _dio.fetch<Map<String, dynamic>>(
              err.requestOptions.copyWith(),
            );
            return handler.resolve(retry);
          }
        } on Object {
          // ignora e segue para o encerramento de sessão
        }
      }
      _onUnauthorized();
    }
    handler.next(err);
  }
}
