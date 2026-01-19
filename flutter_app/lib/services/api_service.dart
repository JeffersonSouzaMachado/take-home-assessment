import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pulsenow_flutter/services/build_uri.dart';
import '../utils/constants.dart';

class ApiService {
  static const String baseUrl = AppConstants.baseServerUrl;

  // TODO: Implement getMarketData() method
  // This should call GET /api/market-data and return the response
  // Example:
  // Future<List<Map<String, dynamic>>> getMarketData() async {
  //   final response = await http.get(Uri.parse('$baseUrl/market-data'));
  //   if (response.statusCode == 200) {
  //     final jsonData = json.decode(response.body);
  //     return List<Map<String, dynamic>>.from(jsonData['data']);
  //   } else {
  //     throw Exception('Failed to load market data: ${response.statusCode}');
  //   }
  // }

  Future<List<Map<String, dynamic>>> getMarketData() async {
    final uri = Uri.parse('$baseUrl/market-data');

    try {
      final response = await http.get(uri, headers: const {
        'Accept': 'application/json'
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'Server returned status code ${response.statusCode}',
        );
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Response is not a JSON object');
      }

      final data = decoded['data'];

      if (data is! List) {
        throw const FormatException('Expected "data" to be a List');
      }

      return List<Map<String, dynamic>>.from(data);
    } on SocketException catch (e) {
      throw Exception(
          'Network error: Unable to reach the server. ${e.message}');
    } on TimeoutException catch (_) {
      throw Exception('Request timeout: The server did not respond in time.');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while loading market data: $e');
    }
  }

  Future<Map<String, dynamic>> getAnalyticsOverview() async {
    return _getJson(AppConstants.analyticsOverviewPath);
  }

  Future<Map<String, dynamic>> getAnalyticsTrends(String timeframe) async {
    const url = AppConstants.analyticsTrendsPath;
    return _getJson(url, queryParameters: {'timeframe': timeframe});
  }

  Future<Map<String, dynamic>> getAnalyticsSentiment() async {
    return _getJson(AppConstants.analyticsSentimentPath);
  }

  Future<Map<String, dynamic>> getPortfolioSummary() async {
    return _getJson(AppConstants.portfolioSummaryPath);
  }

  Future<Map<String, dynamic>> getPortfolioHoldings() async {
    return _getJson(AppConstants.portfolioHoldingsPath);
  }

  Future<Map<String, dynamic>> getPortfolioPerformance(String timeframe) {
    return _getJson(
      AppConstants.portfolioPerformancePath,
      queryParameters: {'timeframe': timeframe},
    );
  }

  Future<Map<String, dynamic>> _getJson(
      String path, {
        Map<String, String>? queryParameters,
      }) async {
    final uri = buildUri(path, queryParameters: queryParameters);
    debugPrint('[ApiService] GET -> $uri');

    try {
      final response = await http.get(uri, headers: const {
        'Accept': 'application/json'
      }).timeout(const Duration(seconds: 10));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
            'Server returned status code ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Response is not a JSON object');
      }

      if (!decoded.containsKey('data')) {
        throw const FormatException('Missing "data" key in response');
      }

      return decoded;
    } on SocketException catch (e) {
      throw Exception(
          'Network error: Unable to reach the server. ${e.message}');
    } on TimeoutException {
      throw Exception('Request timeout: The server did not respond in time.');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while loading analytics data: $e');
    }
  }

  Future<Map<String, dynamic>> addPortfolioTransaction(Map<String, dynamic> transaction) async {
    final uri = buildUri(AppConstants.portfolioTransactionsPath);

    try {
      final response = await http
          .post(
            uri,
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(transaction),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
            'Server returned status code ${response.statusCode}');
      }

      final decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Response is not a JSON object');
      }

      return decoded;
    } on SocketException catch (e) {
      throw Exception(
          'Network error: Unable to reach the server. ${e.message}');
    } on TimeoutException {
      throw Exception('Request timeout: The server did not respond in time.');
    } on FormatException catch (e) {
      throw Exception('Invalid response format: ${e.message}');
    } on HttpException catch (e) {
      throw Exception('HTTP error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error while adding transaction: $e');
    }
  }
}
