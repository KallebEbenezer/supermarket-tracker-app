import 'package:flutter/material.dart' hide SnackBar, IconButton;
import 'package:flutter/material.dart' as material show IconButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../../features/_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/credentials.dart';

/// Tela de cadastro (registro completo). Cria usuário + credencial no backend
/// e persiste a sessão.
class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscure = true;
  bool _submitting = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final senha = _passwordController.text;

    if (nome.isEmpty || email.isEmpty || senha.isEmpty) {
      SnackBar.show(context, message: l10n.signupErrorEmpty, type: SnackBarType.warning);
      return;
    }

    setState(() => _submitting = true);
    try {
      await ref.read(authRepositoryProvider).registro(SignupPayload(
            nome: nome,
            email: email,
            senha: senha,
            telefone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
          ));
      if (mounted) context.go('/dashboard');
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
      appBar: AppBar(title: Text(l10n.signupTitle)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 360),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.signupSubtitle, style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: AppSpacing.lg),
                AppTextField(
                  controller: _nomeController,
                  label: l10n.signupName,
                  prefixIcon: const Icon(AppIcons.person),
                ),
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _emailController,
                  label: l10n.loginUsername,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(AppIcons.email),
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
                const SizedBox(height: AppSpacing.md),
                AppTextField(
                  controller: _phoneController,
                  label: l10n.signupPhone,
                  keyboardType: TextInputType.phone,
                  prefixIcon: const Icon(AppIcons.phone),
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: l10n.signupSubmit,
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
                    Text(l10n.signupHasAccount),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: Text(l10n.loginSubmit),
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
