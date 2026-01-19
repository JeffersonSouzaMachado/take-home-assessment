class AnalyticsTrends {
  final String timeframe;
  final List<double> prices;

  const AnalyticsTrends({
    required this.timeframe,
    required this.prices,
  });

  factory AnalyticsTrends.fromJson(Map<String, dynamic> json) {
    // ✅ 1) timeframe vem direto
    final timeframe = (json['timeframe'] ?? '').toString();

    // ✅ 2) a lista vem em json['data']
    final raw = json['data'];
    final list = raw is List ? raw : const [];

    // ✅ 3) cada item tem priceIndex (num)
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
