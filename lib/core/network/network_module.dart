import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../cache/cache_service.dart';
import '../connectivity/connectivity_service.dart';
import '../environment/app_environment.dart';
import '../session/session_manager.dart';
import 'api_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/cache_interceptor.dart';
import 'interceptors/network_logger_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'network_request_monitor.dart';

abstract final class NetworkModule {
  static Dio createDio({
    required AppEnvironment environment,
    required SessionManager sessionManager,
    required ConnectivityService connectivity,
    required CacheService cache,
    required Logger logger,
    required NetworkRequestMonitor monitor,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: environment.apiBaseUrl,
        // Timeouts generosos: o backend no Render (plano gratuito) hiberna após
        // 15 min de inatividade e o primeiro request sofre cold start (~30-60s).
        connectTimeout: const Duration(seconds: 60),
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 90),
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );

    // Autenticação via JWT Bearer. O AuthInterceptor anexa o access token e
    // renova automaticamente em 401 usando o refresh token; falhando, encerra
    // a sessão e o roteador redireciona para o login.
    dio.interceptors.addAll([
      AuthInterceptor(
        sessionManager,
        dio,
        () => sessionManager.clear(),
      ),
      RetryInterceptor(dio, connectivity),
      CacheInterceptor(cache),
      NetworkLoggerInterceptor(logger, monitor, environment),
    ]);
    return dio;
  }

  static ApiClient createApiClient(Dio dio) => DioApiClient(dio);
}