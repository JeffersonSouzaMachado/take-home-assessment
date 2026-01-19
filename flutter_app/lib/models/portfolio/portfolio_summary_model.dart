class PortfolioSummary {
  final double totalValue;
  final double totalPnl;
  final double totalPnlPercent;

  const PortfolioSummary({
    required this.totalValue,
    required this.totalPnl,
    required this.totalPnlPercent,
  });

  factory PortfolioSummary.fromJson(Map<String, dynamic> json) {
    return PortfolioSummary(
      totalValue: _toDouble(json['totalValue'] ?? json['total_value']),
      totalPnl: _toDouble(json['totalPnl'] ?? json['total_pnl']),
      totalPnlPercent: _toDouble(json['totalPnlPercent'] ?? json['total_pnl_percent']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
