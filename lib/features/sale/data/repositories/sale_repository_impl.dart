import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/sale_entity.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/sale_remote_data_source.dart';

class SaleRepositoryImpl implements SaleRepository {
  SaleRepositoryImpl(this._remote);

  final SaleRemoteDataSource _remote;

  @override
  Future<SaleEntity> finalizeSale(Map<String, dynamic> payload) async {
    try {
      final envelope = await _remote.finalizeSale(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<SaleEntity> getSale(String saleId) async {
    try {
      final envelope = await _remote.getSale(saleId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
