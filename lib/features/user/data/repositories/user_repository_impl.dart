import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_remote_data_source.dart';

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._remote);

  final UserRemoteDataSource _remote;

  @override
  Future<List<UserEntity>> listUsers(String companyId) async {
    try {
      final envelope = await _remote.listUsers(companyId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<UserEntity> createUser(Map<String, dynamic> payload) async {
    try {
      final envelope = await _remote.createUser(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
