import 'package:flutter/material.dart';
import 'package:pulsenow_flutter/services/api_service.dart';

class PortfolioProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, dynamic>? _summary;
  List<dynamic> _holdings = [];
  bool _isLoading = false;
  String? _error;
  Map<String, dynamic>? _performance;

  Map<String, dynamic>? get summary => _summary;

  List<dynamic> get holdings => _holdings;

  bool get isLoading => _isLoading;

  String? get error => _error;

  Map<String, dynamic>? get performance => _performance;

  // TODO: Implement methods
  // - loadPortfolioSummary()
  // - loadHoldings()
  // - loadPerformance(String timeframe)
  // - addTransaction(Map<String, dynamic> transaction)

  String mapErrorToUserMessage(Object error) {
    final msg = error.toString();

    if (msg.startsWith('Exception: ')) {
      return msg.replaceFirst('Exception: ', '').trim();
    }

    return 'Unable to load portfolio data. Please try again.';
  }

  Future<void> loadPortfolioSummary() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getPortfolioSummary();
      _summary = response['data'];
    } catch (e, stackTrace) {
      debugPrint('PortfolioProvider.loadPortfolioSummary failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      _error = mapErrorToUserMessage(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }

    Future<void> loadHoldings() async {
      _isLoading = true;
      _error = null;
      notifyListeners();

      try {
        final response = await _apiService.getPortfolioHoldings();
        _holdings = response['data'] as List<dynamic>;
      } catch (e, stackTrace) {
        debugPrint('PortfolioProvider.loadHoldings failed: $e');
        debugPrintStack(stackTrace: stackTrace);
        _error = mapErrorToUserMessage(e);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }

    Future<void> loadPerformance(String timeframe) async {
      _isLoading = true;
      _error = null;
      notifyListeners();

      try {
        final response = await _apiService.getPortfolioPerformance(timeframe);
        _performance = response['data'];
      } catch (e, stackTrace) {
        debugPrint('PortfolioProvider.loadPerformance failed: $e');
        debugPrintStack(stackTrace: stackTrace);
        _error = mapErrorToUserMessage(e);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }

    Future<void> addTransaction(Map<String, dynamic> transaction) async {
      _isLoading = true;
      _error = null;
      notifyListeners();

      try {
        await _apiService.addPortfolioTransaction(transaction);

        // Refresh holdings after adding a transaction
        await loadHoldings();
      } catch (e, stackTrace) {
        debugPrint('PortfolioProvider.addTransaction failed: $e');
        debugPrintStack(stackTrace: stackTrace);
        _error = mapErrorToUserMessage(e);
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }
  }
}
