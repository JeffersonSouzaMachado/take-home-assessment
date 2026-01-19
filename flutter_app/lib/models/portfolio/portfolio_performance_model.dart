class PortfolioPerformance {
  final String timeframe;
  final List<double> values;

  const PortfolioPerformance({
    required this.timeframe,
    required this.values,
  });

  factory PortfolioPerformance.fromJson(Map<String, dynamic> json) {
    final rawValues = json['values'] ?? json['points'] ?? [];
    return PortfolioPerformance(
      timeframe: (json['timeframe'] ?? '').toString(),
      values: _toDoubleList(rawValues),
    );
  }

  static List<double> _toDoubleList(dynamic value) {
    if (value is! List) return const [];
    return value.map((e) => _toDouble(e)).toList();
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
