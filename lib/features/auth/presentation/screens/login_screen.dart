import 'package:flutter/material.dart' hide SnackBar, IconButton;
import 'package:flutter/material.dart' as material show IconButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../../features/_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/credentials.dart';

/// Tela de login (JWT Bearer). Autentica via `/api/v1/auth/login`, persiste a
/// sessão em [SessionManager] e deixa o roteador redirecionar ao painel.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      SnackBar.show(context, message: l10n.loginErrorEmpty, type: SnackBarType.warning);
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref
          .read(authRepositoryProvider)
          .login(LoginCredentials(email: email, senha: password));
      if (mounted) context.go('/dashboard');
    } on AppException catch (error) {
      if (mounted) {
        SnackBar.show(context, message: error.message, type: SnackBarType.error);
      }
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.loginTitle,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  l10n.loginSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _emailController,
                  label: l10n.loginUsername,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(AppIcons.person),
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
                const SizedBox(height: AppSpacing.sm),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go('/forgot-password'),
                    child: Text(l10n.loginForgotPassword),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                PrimaryButton(
                  label: l10n.loginSubmit,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(l10n.loginNoAccount),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: Text(l10n.signupTitle),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
