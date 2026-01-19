import 'package:flutter/foundation.dart';
import 'package:pulsenow_flutter/models/market_history_point.dart';
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

  String _selectedSymbol = 'BTC/USD';

  String get selectedSymbol => _selectedSymbol;

  final Map<String, List<MarketHistoryPoint>> _historyCache = {};

  List<MarketHistoryPoint> get selectedHistory =>
      _historyCache['${selectedSymbol}|${_selectedTimeframe}'] ?? const [];


  bool _isHistoryLoading = false;

  bool get isHistoryLoading => _isHistoryLoading;

  String _selectedTimeframe = '1h';
  String get selectedTimeframe => _selectedTimeframe;


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
      (event) {
        if (!_isRealtimeConnected) {
          _isRealtimeConnected = true;
          notifyListeners();
        }

        if (event['type'] != 'market_update') return;

        final payload = event['data'];
        if (payload is! Map<String, dynamic>) return;

        final update = MarketData.fromJson(payload);
        _upsert(update);
      },
      onError: (e, stackTrace) {
        _isRealtimeConnected = false;
        notifyListeners();

        debugPrint('MarketDataProvider WebSocket data error: $e');
        if (stackTrace != null) debugPrintStack(stackTrace: stackTrace);
      },
      onDone: () {
        _isRealtimeConnected = false;
        notifyListeners();
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

  Future<void> selectSymbol(String symbol) async {
    _selectedSymbol = symbol;
    notifyListeners();
    await loadHistoryForSelected(); // usa selectedSymbol internamente
  }

  Future<void> loadHistoryForSelected({String timeframe = '1h', int limit = 100}) async {
    _isHistoryLoading = true;
    notifyListeners();

    try {
      final symbol = selectedSymbol;
      final response = await _apiService.getMarketHistory(symbol, timeframe, limit);

      final data = response['data'];
      List list;

      if (data is List) {
        list = data;
      } else if (data is Map<String, dynamic> && data['data'] is List) {
        list = data['data'] as List;
      } else {
        list = const [];
      }

      final points = list
          .whereType<Map<String, dynamic>>()
          .map((e) => MarketHistoryPoint.fromJson(e))
          .toList();

      _historyCache['$symbol|$timeframe'] = points;
    } finally {
      _isHistoryLoading = false;
      notifyListeners();
    }
  }


  Future<void> setTimeframe(String timeframe) async {
    if (_selectedTimeframe == timeframe) return;
    _selectedTimeframe = timeframe;
    notifyListeners();
    await loadHistoryForSelected(timeframe: timeframe);
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
