import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils/constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  final StreamController<Map<String, dynamic>> _dataController =
      StreamController<Map<String, dynamic>>.broadcast();

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  StreamSubscription? _channelSubscription;
  Timer? _reconnectTimer;

  bool _shouldReconnect = false;
  bool _isConnected = false;
  int _reconnectAttempt = 0;

  Stream<Map<String, dynamic>> get stream => _dataController.stream;
  Stream<bool> get connectionStream => _connectionController.stream;
  bool get isConnected => _isConnected;

  void connect({bool autoReconnect = true}) {
    _shouldReconnect = autoReconnect;

    if (_channel != null) return;

    _open();
  }

  void disconnect() {
    _shouldReconnect = false;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _reconnectAttempt = 0;

    _channelSubscription?.cancel();
    _channelSubscription = null;

    _channel?.sink.close();
    _channel = null;

    _setConnected(false);
  }

  void dispose() {
    disconnect();
    _dataController.close();
    _connectionController.close();
  }

  void _open() {
    try {
      final uri = Uri.parse(AppConstants.wsUrl);
      _channel = WebSocketChannel.connect(uri);
      _setConnected(true);

      _channelSubscription = _channel!.stream.listen(
        (message) {
          try {
            final decoded = jsonDecode(message);

            if (decoded is Map<String, dynamic>) {
              _dataController.add(decoded);
              return;
            }

            _dataController.addError(
              const FormatException('WebSocket message is not a JSON object'),
            );
          } catch (e) {
            _dataController.addError(
              FormatException('Invalid WebSocket JSON format: $e'),
            );
          }
        },
        onError: (error, stackTrace) {
          debugPrint('WebSocket error: $error');
          if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);

          _setConnected(false);
          _cleanupChannel();
          _scheduleReconnect();
        },
        onDone: () {
          _setConnected(false);
          _cleanupChannel();
          _scheduleReconnect();
        },
        cancelOnError: true,
      );

      _reconnectAttempt = 0;
    } catch (e, stackTrace) {
      debugPrint('Failed to connect to WebSocket: $e');
      debugPrintStack(stackTrace: stackTrace);

      _setConnected(false);
      _cleanupChannel();
      _scheduleReconnect();
    }
  }

  void _cleanupChannel() {
    _channelSubscription?.cancel();
    _channelSubscription = null;

    try {
      _channel?.sink.close();
    } catch (_) {
    }

    _channel = null;
  }

  void _scheduleReconnect() {
    if (!_shouldReconnect) return;
    if (_reconnectTimer != null) return;
    if (_dataController.isClosed || _connectionController.isClosed) return;

    final delaySeconds = _backoffSeconds(_reconnectAttempt);
    _reconnectAttempt = (_reconnectAttempt + 1).clamp(0, 30);

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () {
      _reconnectTimer = null;
      if (!_shouldReconnect) return;
      if (_channel != null) return;
      _open();
    });
  }

  int _backoffSeconds(int attempt) {
    final cappedAttempt = attempt.clamp(0, 5);
    final value = 1 << cappedAttempt;
    return value > 30 ? 30 : value;
  }

  void _setConnected(bool value) {
    if (_isConnected == value) return;
    _isConnected = value;

    if (!_connectionController.isClosed) {
      _connectionController.add(value);
    }
  }
}
