class MarketHistoryPoint {
  final DateTime timestamp;
  final double price;

  const MarketHistoryPoint({
    required this.timestamp,
    required this.price,
  });

  factory MarketHistoryPoint.fromJson(Map<String, dynamic> json) {
    return MarketHistoryPoint(
      timestamp: DateTime.tryParse((json['timestamp'] ?? '').toString()) ?? DateTime.now(),
      price: _toDouble(json['price'] ?? json['close'] ?? json['value']),
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
