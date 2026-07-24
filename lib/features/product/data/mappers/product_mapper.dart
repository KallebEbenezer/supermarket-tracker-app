import '../../domain/entities/product_entity.dart';

/// Mapper responsável por converter entre
/// JSON da API e entidades de domínio imutáveis.
class ProductMapper {
  /// Converte JSON bruto da API para [ProductEntity].
  ProductEntity fromJson(Map<String, dynamic> json) {
    return ProductEntity(
      id: json['id'] as String? ?? '',
      empresaId: json['empresaId'] as String? ?? '',
      codigoBarras: json['codigoBarras'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      precoVenda: (json['precoVenda'] as num?)?.toDouble() ?? 0.0,
      estoqueAtual: (json['estoqueAtual'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
    );
  }

  /// Converte [ProductEntity] para JSON enviado ao backend.
  Map<String, dynamic> toJson(ProductEntity e) {
    return {
      'empresaId': e.empresaId,
      'codigoBarras': e.codigoBarras,
      'nome': e.nome,
    };
  }

  /// Converte uma lista de JSONs para [ProductEntity].
  List<ProductEntity> fromJsonList(List<dynamic> list) {
    return list
        .map((j) => fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
