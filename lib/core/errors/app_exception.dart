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
