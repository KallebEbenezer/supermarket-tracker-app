import 'dart:developer' as developer;

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../../environment/app_environment.dart';
import '../models/request_metric.dart';
import '../network_request_monitor.dart';

class NetworkLoggerInterceptor extends Interceptor {
  NetworkLoggerInterceptor(this._logger, this._monitor, this._environment);

  final Logger _logger;
  final NetworkRequestMonitor _monitor;
  final AppEnvironment _environment;

  static const _startedAtKey = 'network.started_at';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra[_startedAtKey] = DateTime.now();
    if (_environment.enableLogs) {
      _logger.d('HTTP → ${options.method} ${options.uri}');
    }
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    _record(response.requestOptions, statusCode: response.statusCode);
    if (_environment.enableLogs) {
      // DEBUG: captura response body para diagnosticar erros do backend.
      // Usa print() para aparecer como tag "flutter" no adb logcat.
      // ignore: avoid_print
      print(
        'HTTP_BODY ← ${response.statusCode} '
        '${response.requestOptions.method} ${response.requestOptions.uri}\n'
        'BODY: ${response.data}',
      );
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _record(
      err.requestOptions,
      statusCode: err.response?.statusCode,
      failed: true,
    );
    if (_environment.enableLogs) {
      // DEBUG: captura erro detalhado do backend para diagnosticar 500 no PIX.
      // ignore: avoid_print
      print(
        'HTTP_ERROR ← ${err.response?.statusCode} '
        '${err.requestOptions.method} ${err.requestOptions.uri}\n'
        'REQ BODY: ${err.requestOptions.data}\n'
        'RESP BODY: ${err.response?.data}\n'
        'ERR: $err',
      );
    }
    handler.next(err);
  }

  void _record(RequestOptions options, {int? statusCode, bool failed = false}) {
    final startedAt = options.extra[_startedAtKey] as DateTime?;
    final duration = startedAt == null
        ? Duration.zero
        : DateTime.now().difference(startedAt);
    final metric = RequestMetric(
      method: options.method,
      path: options.uri.path,
      duration: duration,
      statusCode: statusCode,
      failed: failed,
    );
    _monitor.record(metric);
    developer.postEvent('supermarket_tracker.network', {
      'method': metric.method,
      'path': metric.path,
      'duration_ms': metric.duration.inMilliseconds,
      'status_code': metric.statusCode,
      'failed': metric.failed,
    });
  }
}
