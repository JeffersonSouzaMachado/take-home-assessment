import 'market_leader_model.dart';

class AnalyticsOverview {
  final double totalMarketCap;
  final double totalVolume24h;
  final int activeMarkets;
  final MarketLeader topGainer;
  final MarketLeader topLoser;

  const AnalyticsOverview({
    required this.totalMarketCap,
    required this.totalVolume24h,
    required this.activeMarkets,
    required this.topGainer,
    required this.topLoser,
  });

  factory AnalyticsOverview.fromJson(Map<String, dynamic> json) {
    return AnalyticsOverview(
      totalMarketCap: _toDouble(json['totalMarketCap']),
      totalVolume24h: _toDouble(json['totalVolume24h']),
      activeMarkets: _toInt(json['activeMarkets']),
      topGainer: MarketLeader.fromJson(json['topGainer'] ?? {}),
      topLoser: MarketLeader.fromJson(json['topLoser'] ?? {}),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    return int.tryParse(value.toString()) ?? 0;
  }
}
