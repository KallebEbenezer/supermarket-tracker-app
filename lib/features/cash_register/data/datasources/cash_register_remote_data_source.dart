import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/cash_register_entity.dart';
import '../../domain/entities/cash_session_entity.dart';

/// Interface that defines the data‑source operations for cash registers.
abstract class CashRegisterRemoteDataSource {
  /// Create a new cash register.
  Future<ApiEnvelope<CashRegisterEntity>> createCashRegister(Map<String, dynamic> payload);

  /// Open a new cash session for a given cash register.
  Future<ApiEnvelope<CashSessionEntity>> openCashSession(
    String cashRegisterId,
    Map<String, dynamic> payload,
  );

  /// Close the current open cash session of a given cash register.
  Future<ApiEnvelope<CashSessionEntity>> closeCurrentCashSession(
    String cashRegisterId,
    Map<String, dynamic> payload,
  );
}
