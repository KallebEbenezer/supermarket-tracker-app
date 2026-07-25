import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/stock_movement_entity.dart';
import '../../domain/repositories/stock_movement_repository.dart';
import '../datasources/stock_movement_remote_data_source.dart';

class StockMovementRepositoryImpl implements StockMovementRepository {
  StockMovementRepositoryImpl(this._remote);

  final StockMovementRemoteDataSource _remote;

  @override
  Future<List<StockMovementEntity>> listStockMovements(
    String companyId, {
    String? storeId,
  }) async {
    try {
      final envelope =
          await _remote.listStockMovements(companyId, storeId: storeId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<StockMovementEntity> registerStockMovement(
    Map<String, dynamic> payload,
  ) async {
    try {
      final envelope = await _remote.registerStockMovement(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
