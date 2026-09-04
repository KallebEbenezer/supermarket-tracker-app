import '../entities/payment_entity.dart';
import '../entities/pix_payment_entity.dart';
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
  Future<List<PaymentEntity>> listPayments(String saleId);
  Future<PixPaymentEntity> getPixDetails(String saleId);
  Future<Map<String, dynamic>> processCardPayment({
    required String vendaId,
    String? contaBancariaId,
    required double valor,
    required String modalidade,
    int parcelas = 1,
    String? referenciaNfc,
  });
}
