import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/bank_account_entity.dart';

/// Lista de contas bancárias por empresa.
final bankAccountListProvider =
    FutureProvider.autoDispose.family<List<BankAccountEntity>, String>(
  (ref, empresaId) =>
      ref.watch(bankAccountRepositoryProvider).listBankAccounts(empresaId),
);

/// Estado do formulário de conta bancária.
class BankAccountFormState {
  const BankAccountFormState({this.submitting = false, this.error});

  final bool submitting;
  final String? error;

  BankAccountFormState copyWith({bool? submitting, String? error}) =>
      BankAccountFormState(
        submitting: submitting ?? this.submitting,
        error: error,
      );
}

/// Notifier para o formulário de conta bancária.
class BankAccountFormNotifier extends Notifier<BankAccountFormState> {
  @override
  BankAccountFormState build() => const BankAccountFormState();

  Future<BankAccountEntity> create(Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final created =
          await ref.read(bankAccountRepositoryProvider).createBankAccount(payload);
      ref.invalidate(bankAccountListProvider(payload['empresaId'] as String));
      state = state.copyWith(submitting: false);
      return created;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao criar conta bancária';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }

  Future<BankAccountEntity> update(
    String id,
    Map<String, dynamic> payload,
  ) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final updated =
          await ref.read(bankAccountRepositoryProvider).updateBankAccount(id, payload);
      ref.invalidate(bankAccountListProvider(payload['empresaId'] as String));
      state = state.copyWith(submitting: false);
      return updated;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao atualizar conta bancária';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }
}

final bankAccountFormProvider =
    NotifierProvider<BankAccountFormNotifier, BankAccountFormState>(
  BankAccountFormNotifier.new,
);
