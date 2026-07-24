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
        400 => BadRequestException(_message(error) ?? 'Requisição inválida'),
        401 => UnauthorizedException(_message(error) ?? 'Sessão expirada'),
        403 => ForbiddenException(_message(error) ?? 'Acesso não permitido'),
        404 => NotFoundException(_message(error) ?? 'Recurso não encontrado'),
        409 => ConflictException(_message(error) ?? 'Conflito de recurso'),
        422 => ValidationException(
          _message(error) ?? 'Erro de validação',
          _extractValidationErrors(error),
        ),
        429 => RateLimitException(_message(error) ?? 'Muitas requisições'),
        500 => ServerException(_message(error) ?? 'Erro interno do servidor'),
        502 => BadGatewayException(_message(error) ?? 'Bad gateway'),
        503 => ServiceUnavailableException(_message(error) ?? 'Serviço indisponível'),
        504 => GatewayTimeoutException(_message(error) ?? 'Gateway timeout'),
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

  static Map<String, String> _extractValidationErrors(DioException error) {
    final data = error.response?.data;
    if (data is Map<String, dynamic> && data['validationErrors'] is Map) {
      final errors = data['validationErrors'] as Map;
      return errors.map((key, value) => MapEntry(key.toString(), value.toString()));
    }
    return const {};
  }
}