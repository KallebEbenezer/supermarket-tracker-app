import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/stock_movement_entity.dart';

/// Interface that defines the data‑source operations for stock movements.
abstract class StockMovementRemoteDataSource {
  /// Register a new stock movement.
  Future<ApiEnvelope<StockMovementEntity>> registerStockMovement(
    Map<String, dynamic> payload,
  );
}
