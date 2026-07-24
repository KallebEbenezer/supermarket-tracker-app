import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../connectivity/connectivity_service.dart';
import '../environment/app_environment.dart';
import '../session/session_manager.dart';
import 'api_client.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/network_logger_interceptor.dart';
import 'interceptors/retry_interceptor.dart';
import 'network_request_monitor.dart';

abstract final class NetworkModule {
  static Dio createDio({
    required AppEnvironment environment,
    required SessionManager sessionManager,
    required ConnectivityService connectivity,
    required Logger logger,
    required NetworkRequestMonitor monitor,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: environment.apiBaseUrl,
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
      ),
    );
    dio.interceptors.addAll([
      AuthInterceptor(sessionManager),
      RetryInterceptor(dio, connectivity),
      NetworkLoggerInterceptor(logger, monitor, environment),
    ]);
    return dio;
  }

  static ApiClient createApiClient(Dio dio) => DioApiClient(dio);
}
