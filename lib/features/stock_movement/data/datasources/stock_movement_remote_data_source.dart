import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/stock_movement_entity.dart';

/// Interface that defines the data‑source operations for stock movements.
abstract class StockMovementRemoteDataSource {
  /// List stock movements for a given company.
  Future<ApiEnvelope<List<StockMovementEntity>>> listStockMovements(
    String companyId, {
    String? storeId,
  });

  /// Register a new stock movement.
  Future<ApiEnvelope<StockMovementEntity>> registerStockMovement(
    Map<String, dynamic> payload,
  );
}
