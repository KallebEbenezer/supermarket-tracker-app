import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/user_entity.dart';

/// Interface that defines the data‑source operations for users.
abstract class UserRemoteDataSource {
  /// Create a new user.
  Future<ApiEnvelope<UserEntity>> createUser(Map<String, dynamic> payload);
}
