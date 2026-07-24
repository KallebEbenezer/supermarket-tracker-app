import '../entities/sale_entity.dart';

/// Contrato de domínio para operações de venda.
abstract class SaleRepository {
  Future<SaleEntity> finalizeSale(Map<String, dynamic> payload);
  Future<SaleEntity> getSale(String saleId);
}
