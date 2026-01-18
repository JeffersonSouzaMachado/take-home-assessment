class MarketLeader {
  final String symbol;
  final double price;
  final double changePercent24h;

  const MarketLeader({
    required this.symbol,
    required this.price,
    required this.changePercent24h,
  });

  factory MarketLeader.fromJson(Map<String, dynamic> json) {
    return MarketLeader(
      symbol: (json['symbol'] ?? '').toString(),
      price: _toDouble(json['price']),
      changePercent24h: _toDouble(json['changePercent24h']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
