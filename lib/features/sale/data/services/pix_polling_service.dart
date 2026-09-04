import 'dart:async';

import '../../domain/repositories/sale_repository.dart';

enum PixPollingResult { approved, timeout, error }

class PixPollingService {
  PixPollingService(this._repository);

  final SaleRepository _repository;

  static const _pollInterval = Duration(seconds: 5);
  static const _timeout = Duration(minutes: 5);

  Stream<PixPollingEvent> poll(String vendaId) async* {
    final stopwatch = Stopwatch()..start();

    while (stopwatch.elapsed < _timeout) {
      yield PixPollingEvent(elapsed: stopwatch.elapsed);

      try {
        final payments = await _repository.listPayments(vendaId);
        final approved = payments.any(
          (p) =>
              p.tipo.toUpperCase() == 'PIX' &&
              p.status.toUpperCase() == 'APROVADO',
        );

        if (approved) {
          yield PixPollingEvent(elapsed: stopwatch.elapsed, approved: true);
          return;
        }
      } on Exception {
        yield PixPollingEvent(elapsed: stopwatch.elapsed, error: true);
      }

      await Future<void>.delayed(_pollInterval);
    }

    yield PixPollingEvent(elapsed: stopwatch.elapsed, timedOut: true);
  }
}

class PixPollingEvent {
  const PixPollingEvent({
    this.elapsed = Duration.zero,
    this.approved = false,
    this.error = false,
    this.timedOut = false,
  });

  final Duration elapsed;
  final bool approved;
  final bool error;
  final bool timedOut;
}
