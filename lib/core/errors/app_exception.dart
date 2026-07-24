sealed class AppException implements Exception {
  const AppException(this.message, {this.statusCode, this.cause});

  final String message;
  final int? statusCode;
  final Object? cause;

  @override
  String toString() => '$runtimeType: $message';
}

class ApiException extends AppException {
  const ApiException(super.message, {super.statusCode, super.cause});
}

class NetworkException extends AppException {
  const NetworkException(super.message, {super.cause});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Sessão não autorizada'])
    : super(statusCode: 401);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'Acesso não permitido'])
    : super(statusCode: 403);
}

class TimeoutException extends AppException {
  const TimeoutException([
    super.message = 'A requisição excedeu o tempo limite',
  ]) : super();
}

/// 400 Bad Request
class BadRequestException extends AppException {
  const BadRequestException(super.message, {super.statusCode = 400, super.cause});
}

/// 404 Not Found
class NotFoundException extends AppException {
  const NotFoundException(super.message,
      {super.statusCode = 404, super.cause});
}

/// 409 Conflict
class ConflictException extends AppException {
  const ConflictException(super.message, {super.statusCode = 409, super.cause});
}

/// 422 Unprocessable Entity (validation)
class ValidationException extends AppException {
  final Map<String, String> fieldErrors;

  const ValidationException(super.message, this.fieldErrors,
      {super.statusCode = 422, super.cause});
}

/// 429 Too Many Requests
class RateLimitException extends AppException {
  const RateLimitException(super.message,
      {super.statusCode = 429, super.cause});
}

/// 500 Internal Server Error
class ServerException extends AppException {
  const ServerException(super.message, {super.statusCode = 500, super.cause});
}

/// 502 Bad Gateway
class BadGatewayException extends AppException {
  const BadGatewayException(super.message,
      {super.statusCode = 502, super.cause});
}

/// 503 Service Unavailable
class ServiceUnavailableException extends AppException {
  const ServiceUnavailableException(super.message,
      {super.statusCode = 503, super.cause});
}

/// 504 Gateway Timeout
class GatewayTimeoutException extends AppException {
  const GatewayTimeoutException(super.message,
      {super.statusCode = 504, super.cause});
}