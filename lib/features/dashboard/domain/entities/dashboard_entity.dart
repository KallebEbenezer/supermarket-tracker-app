// ignore_for_file: public_member_api_docs

// Campos espelhados de DashboardResponse (backend).

/// Entidade de domínio para Dashboard.
/// Imutável e livre de dependências externas.
/// Representa o DashboardResponse aninhado do backend, achatado.
class DashboardEntity {
  final double totalVendidoMes;
  final double lucroMes;
  final double prejuizoMes;
  final double ticketMedioMes;
  final int vendasDoDia;
  final int vendasDoMes;
  final List<Map<String, dynamic>> ultimasVendas;
  final List<Map<String, dynamic>> produtosMaisVendidos;
  final List<Map<String, dynamic>> estoqueBaixo;

  const DashboardEntity({
    required this.totalVendidoMes,
    required this.lucroMes,
    required this.prejuizoMes,
    required this.ticketMedioMes,
    required this.vendasDoDia,
    required this.vendasDoMes,
    this.ultimasVendas = const [],
    this.produtosMaisVendidos = const [],
    this.estoqueBaixo = const [],
  });

  DashboardEntity copyWith({
    double? totalVendidoMes,
    double? lucroMes,
    double? prejuizoMes,
    double? ticketMedioMes,
    int? vendasDoDia,
    int? vendasDoMes,
    List<Map<String, dynamic>>? ultimasVendas,
    List<Map<String, dynamic>>? produtosMaisVendidos,
    List<Map<String, dynamic>>? estoqueBaixo,
  }) {
    return DashboardEntity(
      totalVendidoMes: totalVendidoMes ?? this.totalVendidoMes,
      lucroMes: lucroMes ?? this.lucroMes,
      prejuizoMes: prejuizoMes ?? this.prejuizoMes,
      ticketMedioMes: ticketMedioMes ?? this.ticketMedioMes,
      vendasDoDia: vendasDoDia ?? this.vendasDoDia,
      vendasDoMes: vendasDoMes ?? this.vendasDoMes,
      ultimasVendas: ultimasVendas ?? this.ultimasVendas,
      produtosMaisVendidos: produtosMaisVendidos ?? this.produtosMaisVendidos,
      estoqueBaixo: estoqueBaixo ?? this.estoqueBaixo,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DashboardEntity &&
        other.totalVendidoMes == totalVendidoMes &&
        other.lucroMes == lucroMes &&
        other.prejuizoMes == prejuizoMes &&
        other.ticketMedioMes == ticketMedioMes &&
        other.vendasDoDia == vendasDoDia &&
        other.vendasDoMes == vendasDoMes &&
        other.ultimasVendas == ultimasVendas &&
        other.produtosMaisVendidos == produtosMaisVendidos &&
        other.estoqueBaixo == estoqueBaixo;
  }

  @override
  int get hashCode => Object.hash(
        totalVendidoMes,
        lucroMes,
        prejuizoMes,
        ticketMedioMes,
        vendasDoDia,
        vendasDoMes,
        ultimasVendas,
        produtosMaisVendidos,
        estoqueBaixo,
      );

  @override
  String toString() =>
      'DashboardEntity(totalVendidoMes: $totalVendidoMes, lucroMes: $lucroMes, prejuizoMes: $prejuizoMes, ticketMedioMes: $ticketMedioMes, vendasDoDia: $vendasDoDia, vendasDoMes: $vendasDoMes, ultimasVendas: $ultimasVendas, produtosMaisVendidos: $produtosMaisVendidos, estoqueBaixo: $estoqueBaixo)';
}
