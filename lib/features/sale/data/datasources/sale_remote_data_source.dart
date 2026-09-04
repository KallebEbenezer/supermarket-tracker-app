import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/pix_payment_entity.dart';
import '../../domain/entities/sale_entity.dart';

/// Interface that defines the data-source operations for sales.
abstract class SaleRemoteDataSource {
  /// List sales for a given company.
  Future<ApiEnvelope<List<SaleEntity>>> listSales(
    String companyId, {
    String? storeId,
    int? limit,
  });

  /// Finalize a sale.
  Future<ApiEnvelope<SaleEntity>> finalizeSale(Map<String, dynamic> payload);

  /// Retrieve a single sale by its ID.
  Future<ApiEnvelope<SaleEntity>> getSale(String saleId);

  /// List payments for a given sale.
  Future<ApiEnvelope<List<PaymentEntity>>> listPayments(String saleId);

  /// Get PIX payment details for a sale.
  Future<ApiEnvelope<PixPaymentEntity>> getPixDetails(String saleId);

  /// Process card payment via NFC.
  Future<ApiEnvelope<Map<String, dynamic>>> processCardPayment({
    required String vendaId,
    String? contaBancariaId,
    required double valor,
    required String modalidade,
    int parcelas = 1,
    String? referenciaNfc,
  });
}
