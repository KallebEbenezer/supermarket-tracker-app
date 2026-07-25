import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/sale_entity.dart';

/// Interface that defines the data‑source operations for sales.
abstract class SaleRemoteDataSource {
  /// List sales for a given company.
  Future<ApiEnvelope<List<SaleEntity>>> listSales(
    String companyId, {
    String? storeId,
    int? limit,
  });

  /// Finalize a sale.
  Future<ApiEnvelope<SaleEntity>> finalizeSale(Map<String, dynamic> payload);

  /// Retrieve a single sale by its ID.
  Future<ApiEnvelope<SaleEntity>> getSale(String saleId);
}
