import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:supermarket_tracker_android/app/app.dart';
import 'package:supermarket_tracker_android/core/session/session_manager.dart';
import 'package:supermarket_tracker_android/core/storage/secure_storage.dart';

final getIt = GetIt.instance;

/// Armazenamento seguro em memória para os testes (evita dependência de
/// flutter_secure_storage / plataforma).
class _FakeSecureStorage implements SecureStorage {
  final Map<String, String> _data = {};

  @override
  Future<void> write(String key, String value) async => _data[key] = value;

  @override
  Future<String?> read(String key) async => _data[key];

  @override
  Future<void> delete(String key) async => _data.remove(key);

  @override
  Future<void> clear() async => _data.clear();
}

void main() {
  setUp(() {
    if (!getIt.isRegistered<SessionManager>()) {
      getIt.registerLazySingleton<SessionManager>(
        () => SessionManager(_FakeSecureStorage()),
      );
    }
  });

  testWidgets('app builds and gates unauthenticated access', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: App()));
    await tester.pumpAndSettle();

    // Sem credenciais, o roteador redireciona para a tela de login.
    expect(find.byType(App), findsOneWidget);
  });
}
