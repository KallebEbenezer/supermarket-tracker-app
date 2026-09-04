import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/di/injection.dart';
import '../../../../core/environment/app_environment.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/pix_payment_entity.dart';
import '../../data/services/payment_websocket_service.dart';

enum PixPaymentStatus {
  loading,
  waiting,
  approved,
  rejected,
  expired,
  error,
}

class PixPaymentState {
  const PixPaymentState({
    this.status = PixPaymentStatus.loading,
    this.pixData,
    this.elapsed = Duration.zero,
    this.errorMessage,
  });

  final PixPaymentStatus status;
  final PixPaymentEntity? pixData;
  final Duration elapsed;
  final String? errorMessage;

  PixPaymentState copyWith({
    PixPaymentStatus? status,
    PixPaymentEntity? pixData,
    Duration? elapsed,
    String? errorMessage,
  }) {
    return PixPaymentState(
      status: status ?? this.status,
      pixData: pixData ?? this.pixData,
      elapsed: elapsed ?? this.elapsed,
      errorMessage: errorMessage,
    );
  }
}

class PixPaymentNotifier extends Notifier<PixPaymentState> {
  PaymentWebSocketService? _webSocketService;
  Timer? _elapsedTimer;
  Timer? _expiryTimer;
  bool _disposed = false;

  @override
  PixPaymentState build() {
    ref.onDispose(_cleanup);
    return const PixPaymentState();
  }

  Future<void> startPayment(String vendaId) async {
    _cleanup();
    state = const PixPaymentState(status: PixPaymentStatus.loading);

    try {
      final repository = ref.read(saleRepositoryProvider);
      final pixData = await repository.getPixDetails(vendaId);

      if (_disposed) return;

      if (pixData.isExpiredByTime) {
        state = PixPaymentState(
          status: PixPaymentStatus.expired,
          pixData: pixData,
        );
        return;
      }

      if (pixData.isApproved) {
        state = PixPaymentState(
          status: PixPaymentStatus.approved,
          pixData: pixData,
        );
        return;
      }

      state = PixPaymentState(
        status: PixPaymentStatus.waiting,
        pixData: pixData,
      );

      _startElapsedTimer();
      _startExpiryTimer(pixData);
      _connectWebSocket(vendaId);
    } catch (e) {
      if (_disposed) return;
      state = PixPaymentState(
        status: PixPaymentStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  void _connectWebSocket(String vendaId) {
    _webSocketService = PaymentWebSocketService();
    _webSocketService!.events.listen((event) {
      if (_disposed) return;

      switch (event) {
        case PaymentWebSocketEvent.approved:
          state = state.copyWith(status: PixPaymentStatus.approved);
          _cleanup();
        case PaymentWebSocketEvent.rejected:
          state = state.copyWith(status: PixPaymentStatus.rejected);
          _cleanup();
        case PaymentWebSocketEvent.error:
          state = state.copyWith(
            status: PixPaymentStatus.error,
            errorMessage: 'Erro de conexão',
          );
        case PaymentWebSocketEvent.disconnected:
          // Reconnection is handled by the service
          break;
      }
    });

    final wsUrl = ref.read(appEnvironmentProvider).webSocketBaseUrl;
    _webSocketService!.connect(vendaId, baseUrl: wsUrl);
  }

  void _startElapsedTimer() {
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_disposed) return;
      state = state.copyWith(
        elapsed: state.elapsed + const Duration(seconds: 1),
      );
    });
  }

  void _startExpiryTimer(PixPaymentEntity pixData) {
    if (pixData.expiracao == null) return;

    final remaining = pixData.expiracao!.difference(DateTime.now());
    if (remaining.isNegative) {
      state = state.copyWith(status: PixPaymentStatus.expired);
      return;
    }

    _expiryTimer = Timer(remaining, () {
      if (_disposed) return;
      if (state.status == PixPaymentStatus.waiting) {
        state = state.copyWith(status: PixPaymentStatus.expired);
        _cleanup();
      }
    });
  }

  Future<void> retry(String vendaId) async {
    await startPayment(vendaId);
  }

  void _cleanup() {
    _webSocketService?.dispose();
    _webSocketService = null;
    _elapsedTimer?.cancel();
    _elapsedTimer = null;
    _expiryTimer?.cancel();
    _expiryTimer = null;
  }
}

final pixPaymentProvider =
    NotifierProvider.autoDispose<PixPaymentNotifier, PixPaymentState>(
  PixPaymentNotifier.new,
);
