import 'package:flutter/material.dart';
import '../../models/portfolio/portfolio_holding_model.dart';

class PortfolioHoldingTile extends StatelessWidget {
  const PortfolioHoldingTile({super.key, required this.holding});

  final PortfolioHolding holding;

  @override
  Widget build(BuildContext context) {
    final isPositive = holding.pnl >= 0;
    final sign = isPositive ? '+' : '';
    final color = isPositive ? Colors.green : Colors.red;

    return Card(
      child: ListTile(
        title: Text(holding.symbol, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(
          'Qty: ${holding.quantity.toStringAsFixed(4)} • Avg: ${_formatCurrency(holding.averagePrice)}',
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(_formatCurrency(holding.currentPrice), style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 2),
            Text(
              '$sign${holding.pnl.toStringAsFixed(2)} ($sign${holding.pnlPercent.toStringAsFixed(2)}%)',
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatCurrency(double value) => '\$${value.toStringAsFixed(2)}';
}
