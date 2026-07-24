import 'package:dio/dio.dart';

import '../errors/error_mapper.dart';

abstract interface class ApiClient {
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) parser,
  });
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) parser,
  });
  Future<T> put<T>(
    String path, {
    Object? data,
    required T Function(dynamic data) parser,
  });
  Future<void> delete(String path, {Object? data});
}

class DioApiClient implements ApiClient {
  DioApiClient(this._dio);

  final Dio _dio;

  @override
  Future<T> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) parser,
  }) => _execute(
    _dio.get<dynamic>(path, queryParameters: queryParameters),
    parser,
  );

  @override
  Future<T> post<T>(
    String path, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    required T Function(dynamic data) parser,
  }) => _execute(
    _dio.post<dynamic>(path, data: data, queryParameters: queryParameters),
    parser,
  );

  @override
  Future<T> put<T>(
    String path, {
    Object? data,
    required T Function(dynamic data) parser,
  }) => _execute(_dio.put<dynamic>(path, data: data), parser);

  @override
  Future<void> delete(String path, {Object? data}) async {
    try {
      await _dio.delete<dynamic>(path, data: data);
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  Future<T> _execute<T>(
    Future<Response<dynamic>> request,
    T Function(dynamic data) parser,
  ) async {
    try {
      return parser((await request).data);
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
