import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../data/services/pix_polling_service.dart';

class PixPollingState {
  const PixPollingState({
    this.isPolling = false,
    this.isApproved = false,
    this.elapsed = Duration.zero,
    this.error,
    this.timedOut = false,
  });

  final bool isPolling;
  final bool isApproved;
  final Duration elapsed;
  final String? error;
  final bool timedOut;

  PixPollingState copyWith({
    bool? isPolling,
    bool? isApproved,
    Duration? elapsed,
    String? error,
    bool? clearError = false,
    bool? timedOut,
  }) {
    return PixPollingState(
      isPolling: isPolling ?? this.isPolling,
      isApproved: isApproved ?? this.isApproved,
      elapsed: elapsed ?? this.elapsed,
      error: clearError == true ? null : (error ?? this.error),
      timedOut: timedOut ?? this.timedOut,
    );
  }
}

class PixPollingNotifier extends Notifier<PixPollingState> {
  StreamSubscription<PixPollingEvent>? _subscription;

  @override
  PixPollingState build() {
    ref.onDispose(_cancel);
    return const PixPollingState();
  }

  void startPolling(String vendaId) {
    _cancel();
    state = const PixPollingState(isPolling: true);

    final repository = ref.read(saleRepositoryProvider);
    final service = PixPollingService(repository);

    _subscription = service.poll(vendaId).listen(
      (event) {
        if (event.approved) {
          state = state.copyWith(
            isPolling: false,
            isApproved: true,
            elapsed: event.elapsed,
          );
          _cancel();
        } else if (event.timedOut) {
          state = state.copyWith(
            isPolling: false,
            timedOut: true,
            elapsed: event.elapsed,
          );
          _cancel();
        } else if (event.error) {
          state = state.copyWith(
            elapsed: event.elapsed,
            error: 'Erro ao verificar pagamento',
          );
        } else {
          state = state.copyWith(
            elapsed: event.elapsed,
            clearError: true,
          );
        }
      },
      onError: (_) {
        state = state.copyWith(
          isPolling: false,
          error: 'Erro inesperado ao verificar pagamento',
        );
      },
    );
  }

  void stopPolling() {
    _cancel();
    state = const PixPollingState();
  }

  void _cancel() {
    _subscription?.cancel();
    _subscription = null;
  }
}

final pixPollingProvider =
    NotifierProvider.autoDispose<PixPollingNotifier, PixPollingState>(
  PixPollingNotifier.new,
);
