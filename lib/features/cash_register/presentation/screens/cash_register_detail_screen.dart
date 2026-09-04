import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/cash_session_entity.dart';
import '../providers/bank_account_provider.dart';
import '../providers/cash_register_providers.dart';

/// Detalhes de um caixa (rota `/cash/:id`).
class CashRegisterDetailScreen extends ConsumerStatefulWidget {
  const CashRegisterDetailScreen({super.key, required this.cashRegisterId});

  final String cashRegisterId;

  @override
  ConsumerState<CashRegisterDetailScreen> createState() =>
      _CashRegisterDetailScreenState();
}

class _CashRegisterDetailScreenState
    extends ConsumerState<CashRegisterDetailScreen> {
  @override
  void initState() {
    super.initState();
    // Sincroniza uma sessão de caixa já aberta no backend (ex.: reaberta após
    // fechar o app, ou aberta em outro dispositivo) para que a venda não fique
    // presa no loop "abra a sessão" / "já existe sessão aberta".
    WidgetsBinding.instance.addPostFrameCallback((_) => _syncOpenSession());
  }

  Future<void> _syncOpenSession() async {
    try {
      final session = await ref
          .read(cashSessionProvider.notifier)
          .loadCurrentSession(widget.cashRegisterId);
      if (session != null) {
        await ref
            .read(sessionManagerProvider)
            .setSessaoCaixaId(session.id);
      } else {
        // Sem sessão aberta no backend: limpa o id persistido para que a tela
        // de venda não use um id obsoleto (sessão fechada em outro ponto).
        await ref.read(sessionManagerProvider).setSessaoCaixaId('');
      }
    } on Object {
      // Falha ao consultar a sessão não deve impedir a navegação na tela.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sessionState = ref.watch(cashSessionProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Cash register info
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.cashRegisterActions,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: AppSpacing.sm),
              AppListTile(
                title: 'ID',
                subtitle: widget.cashRegisterId,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Active session section
        if (sessionState.hasActiveSession) ...[
          _ActiveSessionSection(
            cashRegisterId: widget.cashRegisterId,
            session: sessionState.currentSession!,
          ),
          const SizedBox(height: AppSpacing.md),
        ],

        // Open/Close session section
        if (!sessionState.hasActiveSession)
          _OpenSessionSection(
            cashRegisterId: widget.cashRegisterId,
            submitting: sessionState.submitting,
          ),

        // Session history
        if (sessionState.sessionHistory.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.md),
          _SessionHistorySection(
            sessions: sessionState.sessionHistory,
          ),
        ],

        // Bank accounts
        const SizedBox(height: AppSpacing.md),
        _BankAccountListSection(
          cashRegisterId: widget.cashRegisterId,
        ),
      ],
    );
  }
}

class _ActiveSessionSection extends ConsumerWidget {
  const _ActiveSessionSection({
    required this.cashRegisterId,
    required this.session,
  });

  final String cashRegisterId;
  final CashSessionEntity session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sessionState = ref.watch(cashSessionProvider);

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cashSessionActive,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppListTile(
            title: l10n.cashOpeningValue,
            subtitle: 'R\$ ${session.valorAbertura.toStringAsFixed(2)}',
          ),
          AppListTile(
            title: l10n.cashObservation,
            subtitle: session.observacao.isNotEmpty
                ? session.observacao
                : '—',
          ),
          if (session.abertoEm.isNotEmpty)
            AppListTile(
              title: 'Aberto em',
              subtitle: session.abertoEm,
            ),
          const SizedBox(height: AppSpacing.md),
          _CloseSessionForm(
            cashRegisterId: cashRegisterId,
            submitting: sessionState.submitting,
          ),
        ],
      ),
    );
  }
}

class _CloseSessionForm extends ConsumerStatefulWidget {
  const _CloseSessionForm({
    required this.cashRegisterId,
    required this.submitting,
  });

  final String cashRegisterId;
  final bool submitting;

  @override
  ConsumerState<_CloseSessionForm> createState() => _CloseSessionFormState();
}

class _CloseSessionFormState extends ConsumerState<_CloseSessionForm> {
  final _valorController = TextEditingController();
  final _observacaoController = TextEditingController();

  @override
  void dispose() {
    _valorController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _closeSession() async {
    final l10n = AppLocalizations.of(context)!;
    final valorText = _valorController.text.trim();
    if (valorText.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    final valor = double.tryParse(valorText);
    if (valor == null) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    final usuarioId =
        ref.read(sessionManagerProvider).currentUser?.id ?? '';

    try {
      await ref.read(cashSessionProvider.notifier).closeSession(
            widget.cashRegisterId,
            {
              'usuarioId': usuarioId,
              'valorFechamento': valor,
              'observacao': _observacaoController.text.trim(),
            },
          );
      await ref.read(sessionManagerProvider).setSessaoCaixaId('');
      if (mounted) {
        SnackBar.show(
          context,
          message: l10n.cashSessionClosed,
          type: SnackBarType.success,
        );
        _valorController.clear();
        _observacaoController.clear();
      }
    } on Object catch (error) {
      if (mounted) {
        final message =
            error is AppException ? error.message : l10n.genericError;
        SnackBar.show(context, message: message, type: SnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      children: [
        AppTextField(
          controller: _valorController,
          label: l10n.cashClosingValue,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _observacaoController,
          label: l10n.cashObservation,
          maxLines: 2,
        ),
        const SizedBox(height: AppSpacing.md),
        PrimaryButton(
          label: l10n.cashSessionClose,
          onPressed: widget.submitting ? null : _closeSession,
        ),
      ],
    );
  }
}

class _OpenSessionSection extends ConsumerStatefulWidget {
  const _OpenSessionSection({
    required this.cashRegisterId,
    required this.submitting,
  });

  final String cashRegisterId;
  final bool submitting;

  @override
  ConsumerState<_OpenSessionSection> createState() =>
      _OpenSessionSectionState();
}

class _OpenSessionSectionState extends ConsumerState<_OpenSessionSection> {
  final _valorController = TextEditingController();
  final _observacaoController = TextEditingController();

  @override
  void dispose() {
    _valorController.dispose();
    _observacaoController.dispose();
    super.dispose();
  }

  Future<void> _openSession() async {
    final l10n = AppLocalizations.of(context)!;
    final valorText = _valorController.text.trim();
    if (valorText.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    final valor = double.tryParse(valorText);
    if (valor == null) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    final usuarioId =
        ref.read(sessionManagerProvider).currentUser?.id ?? '';

    try {
      final session = await ref.read(cashSessionProvider.notifier).openSession(
            widget.cashRegisterId,
            {
              'usuarioId': usuarioId,
              'valorAbertura': valor,
              'observacao': _observacaoController.text.trim(),
            },
          );
      await ref.read(sessionManagerProvider).setSessaoCaixaId(session.id);
      if (mounted) {
        SnackBar.show(
          context,
          message: l10n.cashSessionOpened,
          type: SnackBarType.success,
        );
        _valorController.clear();
        _observacaoController.clear();
      }
    } on Object catch (error) {
      if (mounted) {
        final message =
            error is AppException ? error.message : l10n.genericError;
        SnackBar.show(context, message: message, type: SnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cashSessionOpen,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _valorController,
            label: l10n.cashOpeningValue,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _observacaoController,
            label: l10n.cashObservation,
            maxLines: 2,
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: l10n.cashSessionOpen,
            onPressed: widget.submitting ? null : _openSession,
          ),
        ],
      ),
    );
  }
}

class _SessionHistorySection extends StatelessWidget {
  const _SessionHistorySection({required this.sessions});

  final List<CashSessionEntity> sessions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.cashSessionHistory,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.sm),
          ...sessions.map(
            (session) => Column(
              children: [
                AppListTile(
                  title: '${session.status} — R\$ ${session.valorAbertura.toStringAsFixed(2)}',
                  subtitle: session.abertoEm.isNotEmpty
                      ? 'Aberto: ${session.abertoEm}'
                      : null,
                ),
                const AppDivider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BankAccountListSection extends ConsumerWidget {
  const _BankAccountListSection({required this.cashRegisterId});

  final String cashRegisterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final bankAccounts = ref.watch(bankAccountListProvider(ref.read(sessionManagerProvider).empresaId ?? ''));

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                l10n.bankAccount,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SecondaryButton(
                label: l10n.linkBankAccount,
                expand: false,
                leadingIcon: const Icon(Icons.add),
                onPressed: () => context.push('/cash/$cashRegisterId/link-bank'),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          bankAccounts.when(
            data: (accounts) => accounts.isEmpty
                ? EmptyState(
                    message: l10n.noBankAccounts,
                  )
                : Column(
                    children: [
                      for (final account in accounts) ...[
                        AppListTile(
                          title: '${account.bancoNome} — ${account.tipo}',
                          subtitle:
                              'Ag: ${account.agencia} | Cc: ${account.conta}${account.principal ? ' ★' : ''}',
                          onTap: () => context
                              .go('/cash/bank-accounts/${account.id}/edit'),
                        ),
                        const AppDivider(),
                      ],
                    ],
                  ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => EmptyState(message: l10n.genericError),
          ),
        ],
      ),
    );
  }
}
