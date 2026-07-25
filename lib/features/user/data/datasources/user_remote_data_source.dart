import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/user_entity.dart';

/// Interface that defines the data‑source operations for users.
abstract class UserRemoteDataSource {
  /// List users for a given company.
  Future<ApiEnvelope<List<UserEntity>>> listUsers(String companyId);

  /// Create a new user.
  Future<ApiEnvelope<UserEntity>> createUser(Map<String, dynamic> payload);
}
