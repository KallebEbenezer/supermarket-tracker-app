import 'package:flutter/material.dart' hide SnackBar, IconButton;
import 'package:flutter/material.dart' as material show IconButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../../features/_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/credentials.dart';

/// Tela de redefinição de senha: utiliza o token recebido para definir nova senha.
class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _tokenController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _tokenController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final token = _tokenController.text.trim();
    final senha = _passwordController.text;

    if (token.isEmpty || senha.isEmpty) {
      SnackBar.show(context, message: l10n.loginErrorEmpty, type: SnackBarType.warning);
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .redefinirSenha(ResetPasswordPayload(token: token, novaSenha: senha));
      if (mounted) {
        SnackBar.show(context, message: l10n.resetSuccess, type: SnackBarType.success);
        context.go('/login');
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
      appBar: AppBar(title: Text(l10n.resetTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.resetSubtitle, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _tokenController,
                  label: l10n.resetToken,
                  prefixIcon: const Icon(AppIcons.key),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _passwordController,
                  label: l10n.loginPassword,
                  obscureText: _obscure,
                  prefixIcon: const Icon(AppIcons.lock),
                  suffixIcon: material.IconButton(
                    icon: Icon(_obscure ? AppIcons.visibility : AppIcons.visibilityOff),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: l10n.resetSubmit,
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
