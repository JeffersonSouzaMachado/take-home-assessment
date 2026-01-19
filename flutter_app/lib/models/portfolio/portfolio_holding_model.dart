class PortfolioHolding {
  final String id;
  final String symbol;
  final double quantity;
  final double averagePrice;
  final double currentPrice;
  final double pnl;
  final double pnlPercent;

  const PortfolioHolding({
    required this.id,
    required this.symbol,
    required this.quantity,
    required this.averagePrice,
    required this.currentPrice,
    required this.pnl,
    required this.pnlPercent,
  });

  factory PortfolioHolding.fromJson(Map<String, dynamic> json) {
    return PortfolioHolding(
      id: (json['id'] ?? '').toString(),
      symbol: (json['symbol'] ?? '').toString(),
      quantity: _toDouble(json['quantity']),
      averagePrice: _toDouble(json['averagePrice'] ?? json['average_price']),
      currentPrice: _toDouble(json['currentPrice'] ?? json['current_price']),
      pnl: _toDouble(json['pnl']),
      pnlPercent: _toDouble(json['pnlPercent'] ?? json['pnl_percent']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }
}
