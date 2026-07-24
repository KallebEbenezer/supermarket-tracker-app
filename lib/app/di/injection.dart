import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../core/connectivity/connectivity_service.dart';
import '../../core/environment/app_environment.dart';
import '../../core/logging/app_logger.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_module.dart';
import '../../core/network/network_request_monitor.dart';
import '../../core/session/session_manager.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/storage_service.dart';

final getIt = GetIt.instance;

final appEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => getIt<AppEnvironment>(),
);

/// Ponto único para registrar dependências de infraestrutura e features.
void configureDependencies(AppEnvironment environment) {
  if (getIt.isRegistered<AppEnvironment>()) {
    getIt.unregister<AppEnvironment>();
  }
  if (getIt.isRegistered<Logger>()) {
    getIt.unregister<Logger>();
  }

  final logger = createAppLogger(environment);
  setAppLogger(logger);

  getIt
    ..registerSingleton<AppEnvironment>(environment)
    ..registerSingleton<Logger>(logger)
    ..registerLazySingleton<SecureStorage>(FlutterSecureStorageService.new)
    ..registerLazySingleton<StorageService>(StorageService.new)
    ..registerLazySingleton<SessionManager>(
      () => SessionManager(getIt<SecureStorage>()),
    )
    ..registerLazySingleton<ConnectivityService>(ConnectivityService.new)
    ..registerLazySingleton<NetworkRequestMonitor>(NetworkRequestMonitor.new)
    ..registerLazySingleton<Dio>(
      () => NetworkModule.createDio(
        environment: getIt<AppEnvironment>(),
        sessionManager: getIt<SessionManager>(),
        connectivity: getIt<ConnectivityService>(),
        logger: getIt<Logger>(),
        monitor: getIt<NetworkRequestMonitor>(),
      ),
    )
    ..registerLazySingleton<ApiClient>(
      () => NetworkModule.createApiClient(getIt<Dio>()),
    );
}
