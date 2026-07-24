import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../../features/_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/credentials.dart';

/// Tela de recuperação de senha: solicita o envio do token de redefinição.
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      SnackBar.show(context, message: l10n.loginErrorEmpty, type: SnackBarType.warning);
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .solicitarReset(ForgotPasswordPayload(email: email));
      if (mounted) {
        SnackBar.show(context, message: l10n.forgotSuccess, type: SnackBarType.success);
        context.go('/reset-password');
      }
    } on AppException catch (error) {
      if (mounted) SnackBar.show(context, message: error.message, type: SnackBarType.error);
    } on Object {
      if (mounted) SnackBar.show(context, message: l10n.genericError, type: SnackBarType.error);
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.forgotSubtitle, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _emailController,
                  label: l10n.loginUsername,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(AppIcons.email),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: l10n.forgotSubmit,
                  onPressed: _submitting ? null : _submit,
                  leadingIcon: _submitting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(AppIcons.check),
                ),
                const SizedBox(height: AppSpacing.md),
                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: Text(l10n.forgotBackToLogin),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
