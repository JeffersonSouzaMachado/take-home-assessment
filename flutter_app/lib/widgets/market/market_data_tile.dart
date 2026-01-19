import 'package:flutter/material.dart';
import '../../models/market_data_model.dart';

class MarketDataTile extends StatelessWidget {
  const MarketDataTile({super.key, required this.item});

  final MarketData item;

  @override
  Widget build(BuildContext context) {
    final isPositive = item.change24h >= 0;
    final changeColor = isPositive ? Colors.green : Colors.red;
    final sign = isPositive ? '+' : '';

    return ListTile(
      title: Text(
        item.symbol,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text('Volume: ${item.volume.toStringAsFixed(0)}'),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatCurrency(item.price),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 2),
          Text(
            '$sign${item.change24h.toStringAsFixed(2)} '
                '($sign${item.changePercent24h.toStringAsFixed(2)}%)',
            style: TextStyle(
              color: changeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}
