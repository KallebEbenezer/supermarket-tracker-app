import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/company_entity.dart';
import '../../domain/repositories/company_repository.dart';
import '../datasources/company_remote_data_source.dart';

class CompanyRepositoryImpl implements CompanyRepository {
  CompanyRepositoryImpl(this._remote);

  final CompanyRemoteDataSource _remote;

  @override
  Future<CompanyEntity> createCompany(Map<String, dynamic> payload) async {
    try {
      final envelope = await _remote.createCompany(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<List<CompanyEntity>> listCompanies(String usuarioId) async {
    try {
      final envelope = await _remote.listCompanies(usuarioId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
