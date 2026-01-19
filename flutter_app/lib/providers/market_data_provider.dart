import 'package:flutter/foundation.dart';
import 'dart:async';
import '../services/api_service.dart';
import '../services/websocket_service.dart';
import '../models/market_data_model.dart';

class MarketDataProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final WebSocketService _wsService = WebSocketService();

  StreamSubscription<Map<String, dynamic>>? _wsDataSubscription;
  StreamSubscription<bool>? _wsConnectionSubscription;

  bool _isRealtimeEnabled = false;
  bool _isRealtimeConnected = false;

  List<MarketData> _marketData = [];
  bool _isLoading = false;
  String? _error;

  List<MarketData> get marketData => _marketData;

  bool get isLoading => _isLoading;

  String? get error => _error;

  bool get isRealtimeEnabled => _isRealtimeEnabled;
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

  void startRealtimeUpdates() {
    if (_isRealtimeEnabled) return;

    _isRealtimeEnabled = true;
    notifyListeners();

    _wsService.connect(autoReconnect: true);

    _wsConnectionSubscription ??= _wsService.connectionStream.listen(
      (connected) {
        _isRealtimeConnected = connected;
        notifyListeners();
      },
      onError: (e, stackTrace) {
        debugPrint('MarketDataProvider WebSocket status error: $e');
        if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
      },
    );

    _wsDataSubscription ??= _wsService.stream.listen(
      (data) {
        final update = MarketData.fromJson(data);
        _upsert(update);
      },
      onError: (e, stackTrace) {
        debugPrint('MarketDataProvider WebSocket data error: $e');
        if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
      },
    );
  }

  void stopRealtimeUpdates() {
    if (!_isRealtimeEnabled) return;

    _isRealtimeEnabled = false;
    _isRealtimeConnected = false;

    _wsDataSubscription?.cancel();
    _wsDataSubscription = null;

    _wsConnectionSubscription?.cancel();
    _wsConnectionSubscription = null;

    _wsService.disconnect();
    notifyListeners();
  }

  void toggleRealtimeUpdates() {
    if (_isRealtimeEnabled) {
      stopRealtimeUpdates();
    } else {
      startRealtimeUpdates();
    }
  }

  void _upsert(MarketData update) {
    final index = _marketData.indexWhere((e) => e.symbol == update.symbol);

    if (index == -1) {
      _marketData = [update, ..._marketData];
      notifyListeners();
      return;
    }

    final copy = List<MarketData>.from(_marketData);
    copy[index] = update;
    _marketData = copy;
    notifyListeners();
  }

  @override
  void dispose() {
    stopRealtimeUpdates();
    _wsService.dispose();
    super.dispose();
  }

  String _mapErrorToUserMessage(Object error) {
    final msg = error.toString();

    if (msg.startsWith('Exception: ')) {
      return msg.replaceFirst('Exception: ', '').trim();
    }

    return 'Unable to load market data. Please try again.';
  }
}
