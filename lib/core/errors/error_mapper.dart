import 'package:dio/dio.dart';

import 'app_exception.dart';

abstract final class ErrorMapper {
  static AppException map(Object error) {
    if (error is AppException) {
      return error;
    }
    if (error is! DioException) {
      return ApiException('Ocorreu um erro inesperado', cause: error);
    }

    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => TimeoutException(),
      DioExceptionType.connectionError => NetworkException(
        'Não foi possível conectar ao servidor',
        cause: error,
      ),
      DioExceptionType.badResponse => _fromStatusCode(
        error.response?.statusCode,
        error,
      ),
      _ => ApiException('Não foi possível concluir a requisição', cause: error),
    };
  }

  static AppException _fromStatusCode(int? statusCode, DioException error) =>
      switch (statusCode) {
        401 => UnauthorizedException(_message(error) ?? 'Sessão expirada'),
        403 => ForbiddenException(_message(error) ?? 'Acesso não permitido'),
        _ => ApiException(
          _message(error) ?? 'Erro na comunicação com o servidor',
          statusCode: statusCode,
          cause: error,
        ),
      };

  static String? _message(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? data['error'] as String?;
    }
    return null;
  }
}
