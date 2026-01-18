import 'package:flutter/foundation.dart';
import 'package:pulsenow_flutter/models/analytics/analytics_overview_model.dart';
import '../services/api_service.dart';

class AnalyticsProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  AnalyticsOverview? _overview;
  Map<String, dynamic>? _trends;
  Map<String, dynamic>? _sentiment;
  bool _isLoading = false;
  String? _error;

  AnalyticsOverview? get overview => _overview;
  Map<String, dynamic>? get trends => _trends;
  Map<String, dynamic>? get sentiment => _sentiment;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  // TODO: Implement methods
  // - loadOverview()
  // - loadTrends(String timeframe)
  // - loadSentiment()
  
  Future<void> loadOverview() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      final response = await _apiService.getAnalyticsOverview();
      _overview = response['data'];
    } catch (e, stackTrace) {
      debugPrint('AnalyticsProvider.loadOverview failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      _error = _mapErrorToUserMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  Future<void> loadTrends(String timeframe) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAnalyticsTrends(timeframe);
      _trends = response['data'];
    } catch (e, stackTrace) {
      debugPrint('AnalyticsProvider.loadTrends failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      _error = _mapErrorToUserMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSentiment() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getAnalyticsSentiment();
      _sentiment = response['data'];
    } catch (e, stackTrace) {
      debugPrint('AnalyticsProvider.loadSentiment failed: $e');
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

    return 'Unable to load analytics data. Please try again.';
  }
}
