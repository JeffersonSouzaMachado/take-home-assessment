class PortfolioSummary {
  final double totalValue;
  final double totalPnl;
  final double totalPnlPercent;
  final int totalHoldings;
  final DateTime lastUpdated;

  const PortfolioSummary({
    required this.totalValue,
    required this.totalPnl,
    required this.totalPnlPercent,
    required this.totalHoldings,
    required this.lastUpdated,
  });

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) {
    return PortfolioSummary(
      totalValue: _toDouble(json['totalValue']),
      totalPnl: _toDouble(json['totalPnl']),
      totalPnlPercent: _toDouble(json['totalPnlPercent']),
      totalHoldings: (json['totalHoldings'] as num?)?.toInt() ?? 0,
      lastUpdated: DateTime.tryParse((json['lastUpdated'] ?? '').toString()) ?? DateTime.now(),
    );
  }

  static double _toDouble(dynamic v) {
    if (v == null) return 0.0;
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString()) ?? 0.0;
  }
}
