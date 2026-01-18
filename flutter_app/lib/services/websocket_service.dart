import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../utils/constants.dart';

class WebSocketService {
  WebSocketChannel? _channel;
  StreamController<Map<String, dynamic>>? _controller;

  // TODO: Implement WebSocket connection
  // - connect()
  // - disconnect()
  // - Stream<Map<String, dynamic>> get stream
  // - Handle real-time market updates

  Stream<Map<String, dynamic>>? get stream => _controller?.stream;

  void connect() {
    if (_channel != null) return;
    _controller ??= StreamController<Map<String, dynamic>>.broadcast();

    try {
      _channel = WebSocketChannel.connect(
        Uri.parse(AppConstants.wsServerUrl),
      );

      _channel!.stream.listen(
        (message) {
          try {
            final decoded = jsonDecode(message);

            if (decoded is Map<String, dynamic>) {
              _controller?.add(decoded);
            } else {
              _controller?.addError(
                const FormatException('WebSocket message is not a JSON object'),
              );
            }
          } catch (e) {
            _controller?.addError(
              FormatException('Invalid WebSocket JSON format: $e'),
            );
          }
        },
        onError: (error) {
          _controller?.addError(
            Exception('WebSocket connection error: $error'),
          );
        },
        onDone: () {
          _controller?.addError(
            Exception('WebSocket connection closed'),
          );
          disconnect();
        },
      );
    } catch (e) {
      _controller?.addError(
        Exception('Failed to connect to WebSocket: $e'),
      );
    }
  }

  void disconnect() {
    _channel?.sink.close();
    _controller?.close();
    _channel = null;
    _controller = null;
  }
}
