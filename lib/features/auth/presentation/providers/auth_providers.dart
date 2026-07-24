import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/session_manager.dart';
import '../../../../features/_shared/presentation/providers/repository_providers.dart';

/// Usuário autenticado atual (para o cabeçalho do app shell).
final currentUserProvider = Provider<AuthUser?>((ref) {
  return ref.watch(sessionManagerProvider).currentUser;
});
