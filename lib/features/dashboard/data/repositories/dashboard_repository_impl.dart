import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/dashboard_remote_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._remote);

  final DashboardRemoteDataSource _remote;

  @override
  Future<DashboardEntity> getDashboard({
    required String companyId,
    String? storeId,
    int limit = 10,
  }) async {
    try {
      final envelope = await _remote.getDashboard(
        companyId: companyId,
        storeId: storeId,
        limit: limit,
      );
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
