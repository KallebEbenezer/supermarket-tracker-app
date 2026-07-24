import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/customer_entity.dart';
import '../../domain/repositories/customer_repository.dart';
import '../datasources/customer_remote_data_source.dart';

class CustomerRepositoryImpl implements CustomerRepository {
  CustomerRepositoryImpl(this._remote);

  final CustomerRemoteDataSource _remote;

  @override
  Future<CustomerEntity> createCustomer(Map<String, dynamic> payload) async {
    try {
      final envelope = await _remote.createCustomer(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
