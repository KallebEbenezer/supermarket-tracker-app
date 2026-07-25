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
  const CashSessionState({this.submitting = false, this.error});

  final bool submitting;
  final String? error;

  CashSessionState copyWith({bool? submitting, String? error}) =>
      CashSessionState(
        submitting: submitting ?? this.submitting,
        error: error,
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
      state = state.copyWith(submitting: false);
      return session;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao abrir sessão';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }

  Future<CashSessionEntity> closeSession(
      String cashRegisterId, Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final session = await ref
          .read(cashRegisterRepositoryProvider)
          .closeCurrentCashSession(cashRegisterId, payload);
      state = state.copyWith(submitting: false);
      return session;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao fechar sessão';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }
}
