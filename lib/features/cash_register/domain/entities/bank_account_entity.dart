/// Entidade de domínio para Conta Bancária vinculada ao caixa.
class BankAccountEntity {
  const BankAccountEntity({
    required this.id,
    required this.empresaId,
    this.bancoCodigo = '',
    this.bancoNome = '',
    this.agencia = '',
    this.conta = '',
    this.tipo = 'CORRENTE',
    this.titularNome = '',
    this.titularDocumento = '',
    this.chavePix = '',
    this.principal = false,
    this.status = 'ATIVO',
  });

  final String id;
  final String empresaId;
  final String bancoCodigo;
  final String bancoNome;
  final String agencia;
  final String conta;
  final String tipo;
  final String titularNome;
  final String titularDocumento;
  final String chavePix;
  final bool principal;
  final String status;

  BankAccountEntity copyWith({
    String? id,
    String? empresaId,
    String? bancoCodigo,
    String? bancoNome,
    String? agencia,
    String? conta,
    String? tipo,
    String? titularNome,
    String? titularDocumento,
    String? chavePix,
    bool? principal,
    String? status,
  }) {
    return BankAccountEntity(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      bancoCodigo: bancoCodigo ?? this.bancoCodigo,
      bancoNome: bancoNome ?? this.bancoNome,
      agencia: agencia ?? this.agencia,
      conta: conta ?? this.conta,
      tipo: tipo ?? this.tipo,
      titularNome: titularNome ?? this.titularNome,
      titularDocumento: titularDocumento ?? this.titularDocumento,
      chavePix: chavePix ?? this.chavePix,
      principal: principal ?? this.principal,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BankAccountEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'BankAccountEntity(id: $id, bancoNome: $bancoNome)';
}
