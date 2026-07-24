import 'dart:async';

import 'models/request_metric.dart';

/// Expõe métricas para observabilidade sem acoplar o core a um fornecedor externo.
class NetworkRequestMonitor {
  final StreamController<RequestMetric> _controller =
      StreamController.broadcast();

  Stream<RequestMetric> get metrics => _controller.stream;

  void record(RequestMetric metric) => _controller.add(metric);
  Future<void> dispose() => _controller.close();
}
