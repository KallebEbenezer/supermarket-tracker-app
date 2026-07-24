/// Payload de login (e-mail + senha).
class LoginCredentials {
  const LoginCredentials({required this.email, required this.senha});

  final String email;
  final String senha;

  Map<String, dynamic> toJson() => {'email': email, 'senha': senha};
}

/// Payload de cadastro (registro completo).
class SignupPayload {
  const SignupPayload({
    required this.nome,
    required this.email,
    required this.senha,
    this.telefone,
    this.papel = 'PROPRIETARIO',
  });

  final String nome;
  final String email;
  final String senha;
  final String? telefone;
  final String papel;

  Map<String, dynamic> toJson() => {
        'nome': nome,
        'email': email,
        'senha': senha,
        'telefone': telefone,
        'papel': papel,
      };
}

/// Payload para solicitar redefinição de senha.
class ForgotPasswordPayload {
  const ForgotPasswordPayload({required this.email});

  final String email;

  Map<String, dynamic> toJson() => {'email': email};
}

/// Payload para redefinir a senha com o token recebido.
class ResetPasswordPayload {
  const ResetPasswordPayload({required this.token, required this.novaSenha});

  final String token;
  final String novaSenha;

  Map<String, dynamic> toJson() => {'token': token, 'novaSenha': novaSenha};
}
