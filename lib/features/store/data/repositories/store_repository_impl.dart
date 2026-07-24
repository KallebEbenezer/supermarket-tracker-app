import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/store_entity.dart';
import '../../domain/repositories/store_repository.dart';
import '../datasources/store_remote_data_source.dart';

class StoreRepositoryImpl implements StoreRepository {
  StoreRepositoryImpl(this._remote);

  final StoreRemoteDataSource _remote;

  @override
  Future<StoreEntity> getStore(String storeId) async {
    try {
      final envelope = await _remote.getStore(storeId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<List<StoreEntity>> listStores(String companyId) async {
    try {
      final envelope = await _remote.listStores(companyId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<StoreEntity> createStore(Map<String, dynamic> payload) async {
    try {
      final envelope = await _remote.createStore(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}