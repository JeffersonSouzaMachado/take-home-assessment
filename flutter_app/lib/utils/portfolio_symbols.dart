class PortfolioSymbols {
  static const List<String> supported = [
    'BTC/USD',
    'ETH/USD',
    'SOL/USD',
    'ADA/USD',
    'XRP/USD',
  ];

  static bool isSupported(String symbol) {
    return supported.contains(symbol);
  }
}
