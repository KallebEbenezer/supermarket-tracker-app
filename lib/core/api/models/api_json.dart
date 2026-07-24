/// Contrato mínimo para requests serializáveis enviados à API.
abstract interface class ApiJson {
  Map<String, dynamic> toJson();
}

/// Request genérico usado quando um modelo de domínio ainda não existe.
class JsonRequest implements ApiJson {
  const JsonRequest(this.value);

  final Map<String, dynamic> value;

  @override
  Map<String, dynamic> toJson() => value;
}

Map<String, dynamic> jsonObject(dynamic value) => Map<String, dynamic>.from(value as Map);

List<Map<String, dynamic>> jsonObjectList(dynamic value) =>
    (value as List).map(jsonObject).toList(growable: false);
