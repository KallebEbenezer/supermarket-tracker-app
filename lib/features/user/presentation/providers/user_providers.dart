import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/user_entity.dart';

final userListProvider =
    FutureProvider.autoDispose.family<List<UserEntity>, String>(
  (ref, companyId) =>
      ref.watch(userRepositoryProvider).listUsers(companyId),
);

class UserCreateState {
  const UserCreateState({this.submitting = false, this.error});

  final bool submitting;
  final String? error;

  UserCreateState copyWith({bool? submitting, String? error}) =>
      UserCreateState(
        submitting: submitting ?? this.submitting,
        error: error,
      );
}

final userCreateProvider =
    NotifierProvider<UserCreateNotifier, UserCreateState>(
  UserCreateNotifier.new,
);

class UserCreateNotifier extends Notifier<UserCreateState> {
  @override
  UserCreateState build() => const UserCreateState();

  Future<UserEntity> create(Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final created =
          await ref.read(userRepositoryProvider).createUser(payload);
      ref.invalidate(userListProvider);
      state = state.copyWith(submitting: false);
      return created;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao criar usuário';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }
}
