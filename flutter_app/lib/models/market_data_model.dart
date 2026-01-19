
class MarketData {
  final String symbol;
  final double price;
  final double change24h;
  final double changePercent24h;
  final double volume;

  const MarketData({
    required this.symbol,
    required this.price,
    required this.change24h,
    required this.changePercent24h,
    required this.volume,
  });

  factory MarketData.fromJson(Map<String, dynamic> json) {
    return MarketData(
      symbol: (json['symbol'] ?? '').toString(),
      price: _toDouble(json['price']),
      change24h: _toDouble(json['change24h']),
      changePercent24h: _toDouble(json['changePercent24h']),
      volume: _toDouble(json['volume']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}


