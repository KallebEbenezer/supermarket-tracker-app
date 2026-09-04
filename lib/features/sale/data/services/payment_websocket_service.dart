import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

enum PaymentWebSocketEvent {
  approved,
  rejected,
  error,
  disconnected,
}

class PaymentWebSocketService {
  WebSocketChannel? _channel;
  Timer? _reconnectTimer;
  Timer? _pingTimer;
  String? _vendaId;
  String? _baseUrl;
  int _reconnectAttempts = 0;
  static const _maxReconnectAttempts = 10;
  static const _baseReconnectDelay = Duration(seconds: 1);
  static const _pingInterval = Duration(seconds: 30);

  final StreamController<PaymentWebSocketEvent> _eventController =
      StreamController<PaymentWebSocketEvent>.broadcast();

  Stream<PaymentWebSocketEvent> get events => _eventController.stream;

  void connect(String vendaId, {required String baseUrl}) {
    _vendaId = vendaId;
    _baseUrl = baseUrl;
    _reconnectAttempts = 0;
    _doConnect();
  }

  void _doConnect() {
    if (_vendaId == null || _baseUrl == null) return;

    final url = '$_baseUrl/ws/payment/$_vendaId';
    debugPrint('Conectando WebSocket pagamento: $url');

    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));

      _channel!.stream.listen(
        (message) {
          _reconnectAttempts = 0;
          _handleMessage(message);
        },
        onError: (error) {
          debugPrint('Erro no WebSocket pagamento: $error');
          _eventController.add(PaymentWebSocketEvent.error);
          _scheduleReconnect();
        },
        onDone: () {
          debugPrint('WebSocket pagamento desconectado');
          _eventController.add(PaymentWebSocketEvent.disconnected);
          _scheduleReconnect();
        },
      );

      _startPing();
    } catch (e) {
      debugPrint('Erro ao conectar WebSocket pagamento: $e');
      _scheduleReconnect();
    }
  }

  void _handleMessage(dynamic message) {
    try {
      final data = jsonDecode(message.toString());
      final status = data['status'] as String?;

      if (status == 'APROVADO') {
        _eventController.add(PaymentWebSocketEvent.approved);
      } else if (status == 'REJEITADO' || status == 'EXPIRADO') {
        _eventController.add(PaymentWebSocketEvent.rejected);
      }
    } catch (e) {
      debugPrint('Erro ao processar mensagem WebSocket: $e');
    }
  }

  void _startPing() {
    _pingTimer?.cancel();
    _pingTimer = Timer.periodic(_pingInterval, (_) {
      if (_channel != null) {
        try {
          _channel!.sink.add(jsonEncode({'type': 'ping'}));
        } catch (e) {
          debugPrint('Erro ao enviar ping: $e');
        }
      }
    });
  }

  void _scheduleReconnect() {
    if (_reconnectAttempts >= _maxReconnectAttempts) {
      debugPrint(' Máximo de tentativas de reconexão atingido');
      return;
    }

    _reconnectTimer?.cancel();
    final delay = _baseReconnectDelay * (1 << _reconnectAttempts);
    _reconnectAttempts++;

    debugPrint(' Reconectando em ${delay.inSeconds}s (tentativa $_reconnectAttempts)');
    _reconnectTimer = Timer(delay, _doConnect);
  }

  void disconnect() {
    _pingTimer?.cancel();
    _reconnectTimer?.cancel();
    _channel?.sink.close();
    _channel = null;
    _vendaId = null;
    _reconnectAttempts = 0;
  }

  void dispose() {
    disconnect();
    _eventController.close();
  }
}
