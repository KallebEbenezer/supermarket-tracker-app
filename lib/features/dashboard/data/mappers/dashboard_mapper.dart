import '../../domain/entities/dashboard_entity.dart';

/// Mapper responsável por converter entre
/// JSON da API (DashboardResponse aninhado) e entidades de domínio imutáveis.
class DashboardMapper {
  /// Converte JSON bruto da API para [DashboardEntity].
  /// O DashboardResponse é um objeto aninhado:
  /// resumo (objeto), ultimasVendas/produtosMaisVendidos/estoqueBaixo (listas).
  /// Parsing defensivo para tolerar ausência/erro de campos.
  DashboardEntity fromJson(Map<String, dynamic> json) {
    final resumo = json['resumo'] as Map<String, dynamic>? ?? {};
    final ultimasRaw = (json['ultimasVendas'] as List?) ?? [];
    final prodRaw = (json['produtosMaisVendidos'] as List?) ?? [];
    final estRaw = (json['estoqueBaixo'] as List?) ?? [];

    return DashboardEntity(
      totalVendidoMes: (resumo['totalVendidoMes'] as num?)?.toDouble() ?? 0.0,
      lucroMes: (resumo['lucroMes'] as num?)?.toDouble() ?? 0.0,
      prejuizoMes: (resumo['prejuizoMes'] as num?)?.toDouble() ?? 0.0,
      ticketMedioMes: (resumo['ticketMedioMes'] as num?)?.toDouble() ?? 0.0,
      vendasDoDia: resumo['vendasDoDia'] as int? ?? 0,
      vendasDoMes: resumo['vendasDoMes'] as int? ?? 0,
      ultimasVendas: ultimasRaw.map((e) => e as Map<String, dynamic>).toList(),
      produtosMaisVendidos: prodRaw.map((e) => e as Map<String, dynamic>).toList(),
      estoqueBaixo: estRaw.map((e) => e as Map<String, dynamic>).toList(),
    );
  }

  /// Dashboard é somente leitura. Retorna mapa vazio válido.
  Map<String, dynamic> toJson(DashboardEntity e) {
    return {};
  }
}
