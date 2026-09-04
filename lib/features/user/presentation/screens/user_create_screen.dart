import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../providers/user_providers.dart';

class UserCreateScreen extends ConsumerStatefulWidget {
  const UserCreateScreen({super.key});

  @override
  ConsumerState<UserCreateScreen> createState() => _UserCreateScreenState();
}

class _UserCreateScreenState extends ConsumerState<UserCreateScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final nome = _nomeController.text.trim();
    final email = _emailController.text.trim();
    final authUser = ref.read(sessionManagerProvider).currentUser;

    if (nome.isEmpty || email.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }
    if (authUser == null) {
      SnackBar.show(
        context,
        message: l10n.genericError,
        type: SnackBarType.error,
      );
      return;
    }

    try {
      final created = await ref.read(userCreateProvider.notifier).create({
        'authUserId': authUser.id,
        'nome': nome,
        'email': email,
        'telefone': _telefoneController.text.trim(),
      });
      if (mounted) {
        SnackBar.show(
          context,
          message: l10n.userCreated,
          type: SnackBarType.success,
        );
        context.go('/users');
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
    final createState = ref.watch(userCreateProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppTextField(
          controller: _nomeController,
          label: l10n.userName,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _emailController,
          label: l10n.userEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _telefoneController,
          label: l10n.userPhone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: l10n.save,
          onPressed: createState.submitting ? null : _submit,
        ),
      ],
    );
  }
}
