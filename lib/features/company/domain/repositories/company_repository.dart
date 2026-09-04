import '../entities/company_entity.dart';

/// Contrato de domínio para operações de empresa.
abstract class CompanyRepository {
  Future<CompanyEntity> createCompany(Map<String, dynamic> payload);
  Future<List<CompanyEntity>> listCompanies(String usuarioId);
}
