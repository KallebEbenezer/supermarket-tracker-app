import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/session/session_manager.dart';
import 'repository_providers.dart';

/// Empresa ID atualmente selecionada pelo usuário.
///
/// Retorna `null` se nenhuma empresa foi selecionada ainda (ex.: usuário novo
/// que ainda não criou uma empresa).
final currentCompanyIdProvider = Provider<String?>((ref) {
  return ref.watch(sessionManagerProvider).empresaId;
});

/// Notifier que permite selecionar a empresa ativa.
class EmpresaIdNotifier extends Notifier<String?> {
  @override
  String? build() => ref.read(sessionManagerProvider).empresaId;

  Future<void> select(String empresaId) async {
    await ref.read(sessionManagerProvider).setEmpresaId(empresaId);
    state = empresaId;
  }
}

final empresaIdNotifierProvider =
    NotifierProvider<EmpresaIdNotifier, String?>(EmpresaIdNotifier.new);
