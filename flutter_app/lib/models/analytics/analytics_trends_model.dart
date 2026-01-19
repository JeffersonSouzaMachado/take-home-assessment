class AnalyticsTrends {
  final String timeframe;
  final List<double> prices;

  const AnalyticsTrends({
    required this.timeframe,
    required this.prices,
  });

  factory AnalyticsTrends.fromJson(Map<String, dynamic> json) {
    final timeframe = (json['timeframe'] ?? '').toString();

    final raw = json['data'];
    final list = raw is List ? raw : const [];

    final prices = list
        .whereType<Map<String, dynamic>>()
        .map((e) => e['priceIndex'])
        .map((v) {
      if (v == null) return 0.0;
      if (v is num) return v.toDouble();
      return double.tryParse(v.toString()) ?? 0.0;
    })
        .toList();

    return AnalyticsTrends(
      timeframe: timeframe,
      prices: prices,
    );
  }
}
