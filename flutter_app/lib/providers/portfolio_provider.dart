import 'package:flutter/material.dart';
import 'package:pulsenow_flutter/models/portfolio/portfolio_holding_model.dart';
import 'package:pulsenow_flutter/models/portfolio/portfolio_performance_model.dart';
import 'package:pulsenow_flutter/models/portfolio/portfolio_summary_model.dart';
import 'package:pulsenow_flutter/models/portfolio/portfolio_transaction_request.dart';
import 'package:pulsenow_flutter/services/api_service.dart';

class PortfolioProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  PortfolioSummary? _summary;
  List<PortfolioHolding> _holdings = [];
  PortfolioPerformance? _performance;

  bool _isLoading = false;
  String? _error;

  PortfolioSummary? get summary => _summary;

  List<PortfolioHolding> get holdings => _holdings;

  PortfolioPerformance? get performance => _performance;

  bool get isLoading => _isLoading;

  String? get error => _error;


  String _mapErrorToUserMessage(Object error) {
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
      final data = response['data'];

      if (data is! Map<String, dynamic>) {
        throw const FormatException(
            'Portfolio summary "data" is not an object');
      }

      _summary = PortfolioSummary.fromJson(data);
      debugPrint(
          'SUMMARY UPDATED -> ${_summary?.totalValue} | ${_summary?.lastUpdated}');
    } catch (e, st) {
      _error = _mapErrorToUserMessage(e);
      debugPrint('loadPortfolioSummary failed: $e');
      debugPrintStack(stackTrace: st);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadHoldings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.getPortfolioHoldings();
      final data = response['data'];

      if (data is! List) {
        throw const FormatException(
            'Portfolio holdings "data" is not a JSON array');
      }

      _holdings = data
          .whereType<Map<String, dynamic>>()
          .map((e) => PortfolioHolding.fromJson(e))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('PortfolioProvider.loadHoldings failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      _error = _mapErrorToUserMessage(e);
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
      final data = response['data'];

      List points;

      if (data is List) {
        points = data;
      } else if (data is Map<String, dynamic>) {
        final inner = data['data'];
        if (inner is List) {
          points = inner;
        } else {
          throw const FormatException(
              'Portfolio performance inner "data" is not a list');
        }
      } else {
        throw const FormatException(
            'Portfolio performance "data" is neither list nor object');
      }

      final values = points
          .whereType<Map<String, dynamic>>()
          .map((e) => e['value'])
          .map((v) =>
              v is num ? v.toDouble() : double.tryParse(v.toString()) ?? 0.0)
          .toList();

      _performance = PortfolioPerformance(
        timeframe: timeframe,
        values: values,
      );
    } catch (e, stackTrace) {
      debugPrint('PortfolioProvider.loadPerformance failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      _error = _mapErrorToUserMessage(e);


    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addTransaction(PortfolioTransactionRequest transaction) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await _apiService.addPortfolioTransaction(transaction.toJson());

      await Future.wait([
        loadPortfolioSummary(),
        loadHoldings(),
      ]);

      if (_error != null) {
        throw Exception(_error);
      }
    } catch (e, stackTrace) {
      debugPrint('PortfolioProvider.addTransaction failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      _error = _mapErrorToUserMessage(e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
