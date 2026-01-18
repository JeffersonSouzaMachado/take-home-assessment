class AnalyticsTrends {
  final String timeframe;
  final List<double> prices;

  const AnalyticsTrends({
    required this.timeframe,
    required this.prices,
  });

  factory AnalyticsTrends.fromJson(Map<String, dynamic> json) {
    return AnalyticsTrends(
      timeframe: (json['timeframe'] ?? '').toString(),
      prices: _toDoubleList(json['prices']),
    );
  }

  static List<double> _toDoubleList(dynamic value) {
    if (value is! List) return [];
    return value.map((e) => _toDouble(e)).toList();
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
