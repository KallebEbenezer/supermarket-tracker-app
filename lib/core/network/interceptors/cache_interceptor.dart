import 'package:dio/dio.dart';

import '../../cache/cache_service.dart';

/// Interceptor que cacheia respostas de GET e as serve quando a rede falha.
///
/// Não cacheia requisições autenticadas sensíveis (POST, PUT, DELETE).
/// O TTL padrão é 30 minutos — ajuste conforme a necessidade de cada endpoint.
class CacheInterceptor extends Interceptor {
  CacheInterceptor(this._cache, {this.ttlMinutes = 30});

  final CacheService _cache;
  final int ttlMinutes;

  @override
  void onResponse(Response<dynamic> response, ResponseInterceptorHandler handler) {
    if (_isCacheable(response.requestOptions)) {
      final data = response.data;
      if (data is Map<String, dynamic>) {
        _cache.put(_cacheKey(response.requestOptions), data);
      }
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_isCacheable(err.requestOptions) && _isNetworkError(err)) {
      final cached = await _cache.get(_cacheKey(err.requestOptions), ttlMinutes: ttlMinutes);
      if (cached != null) {
        handler.resolve(Response<dynamic>(
          requestOptions: err.requestOptions,
          data: cached,
          statusCode: 200,
          statusMessage: 'OK (cached)',
        ));
        return;
      }
    }
    handler.next(err);
  }

  bool _isCacheable(RequestOptions options) =>
      options.method.toUpperCase() == 'GET' &&
      !options.path.contains('/auth/');

  bool _isNetworkError(DioException err) =>
      err.type == DioExceptionType.connectionError ||
      err.type == DioExceptionType.connectionTimeout ||
      err.type == DioExceptionType.receiveTimeout;

  String _cacheKey(RequestOptions options) {
    final params = options.queryParameters.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    return '${options.path}${params.isNotEmpty ? '?$params' : ''}';
  }
}
