import '../entities/sale_entity.dart';

/// Contrato de domínio para operações de venda.
abstract class SaleRepository {
  Future<List<SaleEntity>> listSales(
    String companyId, {
    String? storeId,
    int? limit,
  });

  Future<SaleEntity> finalizeSale(Map<String, dynamic> payload);
  Future<SaleEntity> getSale(String saleId);
}
