import '../../domain/entities/store_entity.dart';

/// Mapper responsável por converter entre
/// JSON da API e entidades de domínio imutáveis.
class StoreMapper {
  /// Converte JSON bruto da API para [StoreEntity].
  StoreEntity fromJson(Map<String, dynamic> json) {
    return StoreEntity(
      id: json['id'] as String? ?? '',
      empresaId: json['empresaId'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  /// Converte [StoreEntity] para JSON enviado ao backend.
  Map<String, dynamic> toJson(StoreEntity e) {
    return {
      'empresaId': e.empresaId,
      'codigo': e.codigo,
      'nome': e.nome,
      'cnpj': '',
      'telefone': '',
    };
  }

  /// Converte uma lista de JSONs para [StoreEntity].
  List<StoreEntity> fromJsonList(List<dynamic> list) {
    return list.map((j) => fromJson(j as Map<String, dynamic>)).toList();
  }
}
