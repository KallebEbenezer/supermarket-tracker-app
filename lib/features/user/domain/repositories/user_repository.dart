import '../entities/user_entity.dart';

/// Contrato de domínio para operações de usuário.
abstract class UserRepository {
  Future<List<UserEntity>> listUsers(String companyId);
  Future<UserEntity> createUser(Map<String, dynamic> payload);
}
