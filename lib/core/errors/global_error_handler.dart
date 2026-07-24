import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// Centraliza erros não tratados do framework e da plataforma.
abstract final class GlobalErrorHandler {
  static void configure(Logger logger) {
    FlutterError.onError = (details) {
      logger.e(
        'Erro não tratado pelo Flutter',
        error: details.exception,
        stackTrace: details.stack,
      );
      FlutterError.presentError(details);
    };

    PlatformDispatcher.instance.onError = (error, stackTrace) {
      logger.e(
        'Erro não tratado pela plataforma',
        error: error,
        stackTrace: stackTrace,
      );
      return true;
    };
  }
}
