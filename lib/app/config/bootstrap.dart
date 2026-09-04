import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/environment/app_environment.dart';
import '../../core/errors/global_error_handler.dart';
import '../../core/logging/app_logger.dart';
import '../../core/session/session_manager.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../di/injection.dart';

/// Inicializa recursos transversais antes da árvore de widgets ser criada.
Future<ProviderContainer> bootstrapApplication() async {
  final environment = await AppEnvironment.load();
  configureDependencies(environment);
  GlobalErrorHandler.configure(appLogger);

  final sessionManager = getIt<SessionManager>();
  // Restaura sessão persistida (tokens, empresaId, lojaId, etc.)
  await sessionManager.restore();

  // Backfill em segundo plano: se o usuário restaurou uma sessão antiga (antes
  // do auto-provisionamento), busca a empresa/loja para que as telas (Caixa,
  // Lojas etc.) não fiquem sem contexto. Não bloqueia a inicialização.
  if (sessionManager.isAuthenticated.value) {
    unawaited(getIt<AuthRepository>().ensureSessionContext());
  }

  appLogger.i('Aplicação iniciada no ambiente ${environment.flavor.name}.');

  return ProviderContainer(
    overrides: [appEnvironmentProvider.overrideWithValue(environment)],
  );
}
