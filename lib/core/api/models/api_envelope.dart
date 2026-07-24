import '../../errors/app_exception.dart';

/// Envelope padrão devolvido pela Supermarket Tracker API.
class ApiEnvelope<T> {
  const ApiEnvelope({
    required this.timestamp,
    required this.status,
    required this.success,
    this.data,
    this.code,
    this.message,
    this.path,
    this.traceId,
    this.validationErrors = const {},
  });

  final DateTime? timestamp;
  final int? status;
  final bool success;
  final T? data;
  final String? code;
  final String? message;
  final String? path;
  final String? traceId;
  final Map<String, String> validationErrors;

  factory ApiEnvelope.fromJson(
    Map<String, dynamic> json,
    T Function(dynamic value) fromData,
  ) {
    final errors = json['validationErrors'];
    return ApiEnvelope<T>(
      timestamp: DateTime.tryParse(json['timestamp'] as String? ?? ''),
      status: json['status'] as int?,
      success: json['success'] as bool? ?? false,
      data: json['data'] == null ? null : fromData(json['data']),
      code: json['code'] as String?,
      message: json['message'] as String?,
      path: json['path'] as String?,
      traceId: json['traceId'] as String?,
      validationErrors: errors is Map
          ? errors.map((key, value) => MapEntry(key.toString(), value.toString()))
          : const {},
    );
  }

  T requireData() {
    if (success && data != null) return data as T;
    throw ApiException(
      message ?? 'A API não retornou dados para a requisição',
      statusCode: status,
    );
  }
}
