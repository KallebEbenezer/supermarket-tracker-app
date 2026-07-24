import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:supermarket_tracker_android/core/errors/app_exception.dart';
import 'package:supermarket_tracker_android/core/errors/error_mapper.dart';

// ignore_for_file: lines_longer_than_80_chars

void main() {
  group('ErrorMapper', () {
    test('map returns ApiException for non-AppException, non-DioException', () {
      final result = ErrorMapper.map('unexpected error');
      expect(result, isA<ApiException>());
      expect(result.statusCode, isNull);
    });

    test('map propagates AppException subclasses unchanged', () {
      final original = ForbiddenException();
      final result = ErrorMapper.map(original);
      expect(identical(result, original), isTrue);
    });

    test('connectionError returns NetworkException', () {
      final err = DioException(
        type: DioExceptionType.connectionError,
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<NetworkException>());
      expect(
        (result as NetworkException).message,
        contains('Não foi possível conectar'),
      );
    });

    test('connectionTimeout returns TimeoutException', () {
      final err = DioException(
        type: DioExceptionType.connectionTimeout,
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<TimeoutException>());
    });

    test('400 returns BadRequestException', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 400,
          data: {'message': 'Requisição inválida'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<BadRequestException>());
      expect(
        (result as BadRequestException).message,
        contains('Requisição inválida'),
      );
    });

    test('401 returns UnauthorizedException with status 401', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 401,
          data: {'message': 'Sessão expirada'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<UnauthorizedException>());
      expect((result as UnauthorizedException).statusCode, 401);
    });

    test('403 returns ForbiddenException', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 403,
          data: {'message': 'Acesso não permitido'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<ForbiddenException>());
    });

    test('404 returns NotFoundException', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 404,
          data: {'message': 'Recurso não encontrado'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<NotFoundException>());
    });

    test('409 returns ConflictException', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 409,
          data: {'message': 'Conflito'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<ConflictException>());
    });

    test('422 returns ValidationException with fieldErrors', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 422,
          data: {
            'message': 'Erro de validação',
            'validationErrors': {
              'email': 'E-mail inválido',
              'password': 'Mínimo 6 caracteres',
            },
          },
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<ValidationException>());
      expect(
        (result as ValidationException).message,
        contains('Erro de validação'),
      );
      expect(
        result.fieldErrors,
        equals({'email': 'E-mail inválido', 'password': 'Mínimo 6 caracteres'}),
      );
    });

    test('429 returns RateLimitException', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 429,
          data: {'message': 'Muitas requisições'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<RateLimitException>());
    });

    test('500 returns ServerException with status 500', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 500,
          data: {'message': 'Erro interno do servidor'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<ServerException>());
      expect((result as ServerException).statusCode, 500);
    });

    test('502 returns BadGatewayException', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 502,
          data: {'message': 'Bad gateway'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<BadGatewayException>());
      expect((result as BadGatewayException).statusCode, 502);
    });

    test('503 returns ServiceUnavailableException', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 503,
          data: {'message': 'Serviço indisponível'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<ServiceUnavailableException>());
    });

    test('504 returns GatewayTimeoutException', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 504,
          data: {'message': 'Gateway timeout'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<GatewayTimeoutException>());
      expect((result as GatewayTimeoutException).statusCode, 504);
    });

    test('unknown status code falls back to ApiException', () {
      final err = DioException(
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 418,
          data: {'message': 'I am a teapot'},
          requestOptions: RequestOptions(),
        ),
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<ApiException>());
      expect((result as ApiException).statusCode, 418);
    });

    test('unknown DioException type falls back to ApiException', () {
      final err = DioException(
        type: DioExceptionType.cancel,
        requestOptions: RequestOptions(),
      );
      final result = ErrorMapper.map(err);
      expect(result, isA<ApiException>());
    });
  });
}