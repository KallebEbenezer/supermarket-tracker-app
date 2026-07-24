import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/product_entity.dart';

/// Interface that defines the data‑source operations for products.
abstract class ProductRemoteDataSource {
  /// Create a new product.
  Future<ApiEnvelope<ProductEntity>> createProduct(Map<String, dynamic> payload);

  /// Retrieve a single product by its ID.
  Future<ApiEnvelope<ProductEntity>> getProduct(String productId);
}
