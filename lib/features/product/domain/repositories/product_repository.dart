import '../entities/product_entity.dart';

/// Contrato de domínio para operações de produto.
abstract class ProductRepository {
  Future<ProductEntity> createProduct(Map<String, dynamic> payload);
  Future<ProductEntity> getProduct(String productId);
}
