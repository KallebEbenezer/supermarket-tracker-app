import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppFlavor { dev, homolog, prod }

class AppEnvironment {
  const AppEnvironment({
    required this.flavor,
    required this.appName,
    required this.enableLogs,
    required this.apiBaseUrl,
  });

  final AppFlavor flavor;
  final String appName;
  final bool enableLogs;
  final String apiBaseUrl;

  /// Converte [apiBaseUrl] para o scheme de WebSocket (`ws://` / `wss://`).
  /// Usado pelo [PaymentWebSocketService] para conectar notificações em tempo real.
  String get webSocketBaseUrl {
    if (apiBaseUrl.startsWith('https://')) {
      return apiBaseUrl.replaceFirst('https://', 'wss://');
    }
    return apiBaseUrl.replaceFirst('http://', 'ws://');
  }

  bool get isProduction => flavor == AppFlavor.prod;

  static Future<AppEnvironment> load() async {
    const flavorName = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    final flavor = AppFlavor.values.byName(flavorName);
    await dotenv.load(fileName: 'assets/config/.env.${flavor.name}');

    return AppEnvironment(
      flavor: flavor,
      appName: dotenv.get('APP_NAME', fallback: 'Supermarket Tracker'),
      enableLogs: dotenv.getBool(
        'ENABLE_LOGS',
        fallback: !flavor.name.contains('prod'),
      ),
      apiBaseUrl: dotenv.get('API_BASE_URL', fallback: ''),
    );
  }
}
