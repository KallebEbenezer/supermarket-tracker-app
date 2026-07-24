import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/environment/app_environment.dart';
import '../../core/errors/global_error_handler.dart';
import '../../core/logging/app_logger.dart';
import '../di/injection.dart';

/// Inicializa recursos transversais antes da árvore de widgets ser criada.
Future<ProviderContainer> bootstrapApplication() async {
  final environment = await AppEnvironment.load();
  configureDependencies(environment);
  GlobalErrorHandler.configure(appLogger);

  appLogger.i('Aplicação iniciada no ambiente ${environment.flavor.name}.');

  return ProviderContainer(
    overrides: [appEnvironmentProvider.overrideWithValue(environment)],
  );
}
