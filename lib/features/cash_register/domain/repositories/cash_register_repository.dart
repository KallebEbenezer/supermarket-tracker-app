import '../entities/cash_register_entity.dart';
import '../entities/cash_session_entity.dart';

/// Contrato de domínio para operações de caixa.
abstract class CashRegisterRepository {
  Future<CashRegisterEntity> createCashRegister(Map<String, dynamic> payload);
  Future<CashSessionEntity> openCashSession(String cashRegisterId, Map<String, dynamic> payload);
  Future<CashSessionEntity> closeCurrentCashSession(
    String cashRegisterId,
    Map<String, dynamic> payload,
  );
}
