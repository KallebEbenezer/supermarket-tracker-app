import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/cash_register_entity.dart';
import '../../domain/entities/cash_session_entity.dart';

final cashRegisterListProvider =
    FutureProvider.autoDispose.family<List<CashRegisterEntity>, String>(
  (ref, storeId) => ref.watch(cashRegisterRepositoryProvider).listCashRegisters(storeId),
);

/// Estado do formulário de criação de caixa.
class CashRegisterCreateState {
  const CashRegisterCreateState({this.submitting = false, this.error});

  final bool submitting;
  final String? error;

  CashRegisterCreateState copyWith({bool? submitting, String? error}) =>
      CashRegisterCreateState(
        submitting: submitting ?? this.submitting,
        error: error,
      );
}

final cashRegisterCreateProvider =
    NotifierProvider<CashRegisterCreateNotifier, CashRegisterCreateState>(
  CashRegisterCreateNotifier.new,
);

class CashRegisterCreateNotifier extends Notifier<CashRegisterCreateState> {
  @override
  CashRegisterCreateState build() => const CashRegisterCreateState();

  Future<CashRegisterEntity> create(Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final created =
          await ref.read(cashRegisterRepositoryProvider).createCashRegister(payload);
      ref.invalidate(cashRegisterListProvider);
      state = state.copyWith(submitting: false);
      return created;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao criar caixa';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }
}

/// Estado do formulário de sessão de caixa.
class CashSessionState {
  const CashSessionState({
    this.submitting = false,
    this.error,
    this.currentSession,
    this.sessionHistory = const [],
  });

  final bool submitting;
  final String? error;
  final CashSessionEntity? currentSession;
  final List<CashSessionEntity> sessionHistory;

  bool get hasActiveSession => currentSession?.status == 'ABERTO';

  CashSessionState copyWith({
    bool? submitting,
    String? error,
    CashSessionEntity? currentSession,
    List<CashSessionEntity>? sessionHistory,
  }) =>
      CashSessionState(
        submitting: submitting ?? this.submitting,
        error: error,
        currentSession: currentSession ?? this.currentSession,
        sessionHistory: sessionHistory ?? this.sessionHistory,
      );
}

final cashSessionProvider =
    NotifierProvider<CashSessionNotifier, CashSessionState>(
  CashSessionNotifier.new,
);

class CashSessionNotifier extends Notifier<CashSessionState> {
  @override
  CashSessionState build() => const CashSessionState();

  Future<CashSessionEntity> openSession(
      String cashRegisterId, Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final session = await ref
          .read(cashRegisterRepositoryProvider)
          .openCashSession(cashRegisterId, payload);
      state = state.copyWith(
        submitting: false,
        currentSession: session,
        sessionHistory: [session, ...state.sessionHistory],
      );
      return session;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao abrir sessão';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }

  /// Carrega a sessão de caixa aberta no backend (se houver) e popula o
  /// estado atual, sem alterar `submitting`. Usado ao abrir a tela de detalhe
  /// para sincronizar uma sessão já aberta (ex.: reaberta após fechar o app).
  ///
  /// Quando o backend não tem sessão aberta (404), limpa `currentSession` para
  /// que a tela reflita o estado real (mostra o formulário de abrir) em vez de
  /// ficar presa numa sessão que já foi fechada em outro ponto.
  Future<CashSessionEntity?> loadCurrentSession(String cashRegisterId) async {
    final session = await ref
        .read(cashRegisterRepositoryProvider)
        .getCurrentCashSession(cashRegisterId);
    if (session != null) {
      state = state.copyWith(
        currentSession: session,
        sessionHistory: [
          for (final s in state.sessionHistory)
            if (s.id == session.id) session else s,
          if (!state.sessionHistory.any((s) => s.id == session.id)) session,
        ],
      );
    } else {
      state = state.copyWith(currentSession: null);
    }
    return session;
  }

  Future<CashSessionEntity> closeSession(
      String cashRegisterId, Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final session = await ref
          .read(cashRegisterRepositoryProvider)
          .closeCurrentCashSession(cashRegisterId, payload);
      final updatedHistory = [
        for (final s in state.sessionHistory)
          if (s.id == session.id) session else s,
      ];
      state = state.copyWith(
        submitting: false,
        currentSession: null,
        sessionHistory: updatedHistory,
      );
      return session;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao fechar sessão';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }

  void reset() {
    state = const CashSessionState();
  }
}
