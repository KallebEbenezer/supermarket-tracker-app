import 'dart:convert';

import '../errors/app_exception.dart';

abstract final class JsonParser {
  static Map<String, dynamic> object(dynamic source) {
    final value = source is String ? jsonDecode(source) : source;
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    throw ApiException('Resposta JSON inválida');
  }

  static List<Map<String, dynamic>> list(dynamic source) {
    final value = source is String ? jsonDecode(source) : source;
    if (value is! List) throw ApiException('Resposta JSON inválida');
    return value.map(object).toList(growable: false);
  }

  static T parse<T>(
    dynamic source,
    T Function(Map<String, dynamic>) fromJson,
  ) => fromJson(object(source));
}
