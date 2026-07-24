import '../entities/stock_movement_entity.dart';

/// Contrato de domínio para operações de movimentação de estoque.
abstract class StockMovementRepository {
  Future<StockMovementEntity> registerStockMovement(
    Map<String, dynamic> payload,
  );
}
