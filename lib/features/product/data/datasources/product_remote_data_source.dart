import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/product_entity.dart';

/// Interface that defines the data‑source operations for products.
abstract class ProductRemoteDataSource {
  /// List products for a given company.
  Future<ApiEnvelope<List<ProductEntity>>> listProducts(String companyId);

  /// Create a new product.
  Future<ApiEnvelope<ProductEntity>> createProduct(Map<String, dynamic> payload);

  /// Retrieve a single product by its ID.
  Future<ApiEnvelope<ProductEntity>> getProduct(String productId);

  /// Update an existing product.
  Future<ApiEnvelope<ProductEntity>> updateProduct(
    String id,
    Map<String, dynamic> payload,
  );

  /// Delete a product by its ID.
  Future<void> deleteProduct(String id);
}
