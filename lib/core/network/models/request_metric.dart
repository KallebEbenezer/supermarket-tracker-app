class RequestMetric {
  const RequestMetric({
    required this.method,
    required this.path,
    required this.duration,
    this.statusCode,
    this.failed = false,
  });

  final String method;
  final String path;
  final Duration duration;
  final int? statusCode;
  final bool failed;
}
