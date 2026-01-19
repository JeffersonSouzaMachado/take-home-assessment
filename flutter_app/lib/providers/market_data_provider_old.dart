import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:pulsenow_flutter/services/websocket_service.dart';
import '../services/api_service.dart';
import '../models/market_data_model.dart';

class MarketDataProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<MarketData> _marketData = [];
  bool _isLoading = false;
  String? _error;

  List<MarketData> get marketData => _marketData;

  bool get isLoading => _isLoading;

  String? get error => _error;

  final WebSocketService _wsService = WebSocketService();
  StreamSubscription<Map<String, dynamic>>? _wsSubscription;
  bool _isRealtimeConnected = false;

  bool get isRealtimeConnected => _isRealtimeConnected;

  // TODO: Implement loadMarketData() method
  // This should:
  // 1. Set _isLoading = true and _error = null
  // 2. Call notifyListeners()
  // 3. Call _apiService.getMarketData()
  // 4. Convert the response to List<MarketData> using MarketData.fromJson
  // 5. Set _marketData with the result
  // 6. Handle errors by setting _error
  // 7. Set _isLoading = false
  // 8. Call notifyListeners() again

  Future<void> loadMarketData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final rawData = await _apiService.getMarketData();

      final parsed = rawData.map((json) => MarketData.fromJson(json)).toList();

      _marketData = parsed;
    } catch (e, stackTrace) {
      debugPrint('MarketDataProvider.loadMarketData failed: $e');
      debugPrintStack(stackTrace: stackTrace);

      _error = _mapErrorToUserMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _mapErrorToUserMessage(Object error) {
    final msg = error.toString();

    if (msg.startsWith('Exception: ')) {
      return msg.replaceFirst('Exception: ', '').trim();
    }

    return 'Unable to load market data. Please try again.';
  }

  void startRealtimeUpdates() {
    if (_isRealtimeConnected) return;

    _wsService.connect();

    _wsSubscription = _wsService.stream?.listen(
      (data) {
        // Expecting shape similar to MarketData JSON
        final update = MarketData.fromJson(data);
        _upsertMarketData(update);
      },
      onError: (e, stackTrace) {
        debugPrint('MarketDataProvider WebSocket error: $e');
        debugPrintStack(stackTrace: stackTrace);
        // Optional: surface a non-blocking message
      },
    );

    _isRealtimeConnected = true;
    notifyListeners();
  }

  void stopRealtimeUpdates() {
    _wsSubscription?.cancel();
    _wsSubscription = null;

    _wsService.disconnect();

    _isRealtimeConnected = false;
    notifyListeners();
  }

  void _upsertMarketData(MarketData update) {
    final index = _marketData.indexWhere((e) => e.symbol == update.symbol);

    if (index == -1) {
      _marketData = [update, ..._marketData];
    } else {
      final copy = List<MarketData>.from(_marketData);
      copy[index] = update;
      _marketData = copy;
    }

    notifyListeners();
  }
}
