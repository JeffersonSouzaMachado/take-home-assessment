enum TransactionType { buy, sell }

class PortfolioTransactionRequest {
  final String symbol;
  final TransactionType type;
  final double quantity;
  final double price;

  const PortfolioTransactionRequest({
    required this.symbol,
    required this.type,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'type': type.name, // "buy" or "sell"
      'quantity': quantity,
      'price': price,
    };
  }
}
