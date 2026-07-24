import 'package:dio/dio.dart';

import '../../connectivity/connectivity_service.dart';

class RetryInterceptor extends Interceptor {
  RetryInterceptor(
    this._dio,
    this._connectivity, {
    this.maxRetries = 2,
    this.retryDelay = const Duration(milliseconds: 400),
  });

  final Dio _dio;
  final ConnectivityService _connectivity;
  final int maxRetries;
  final Duration retryDelay;
  static const _retryCountKey = 'network.retry_count';

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final options = err.requestOptions;
    final retries = options.extra[_retryCountKey] as int? ?? 0;
    if (!_canRetry(err, retries) || !await _connectivity.isConnected) {
      handler.next(err);
      return;
    }

    options.extra[_retryCountKey] = retries + 1;
    await Future<void>.delayed(retryDelay * (retries + 1));
    try {
      handler.resolve(await _dio.fetch<dynamic>(options));
    } on DioException catch (retryError) {
      handler.next(retryError);
    }
  }

  bool _canRetry(DioException error, int retries) =>
      retries < maxRetries &&
      error.requestOptions.method.toUpperCase() == 'GET' &&
      (error.type == DioExceptionType.connectionError ||
          error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout);
}
