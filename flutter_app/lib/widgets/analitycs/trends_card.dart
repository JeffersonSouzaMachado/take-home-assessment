import 'package:flutter/material.dart';

import '../../models/analytics/analytics_trends_model.dart';

class TrendsCard extends StatelessWidget {
  const TrendsCard({super.key, required this.data});

  final AnalyticsTrends data;

  @override
  Widget build(BuildContext context) {
    final prices = data.prices;
    if (prices.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No trends data available.'),
        ),
      );
    }

    final first = prices.first;
    final latest = prices.last;
    final delta = latest - first;
    final percent = first == 0 ? 0.0 : (delta / first) * 100;

    final isPositive = delta >= 0;
    final sign = isPositive ? '+' : '';
    final color = isPositive ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Timeframe: ${data.timeframe}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Start: \$${first.toStringAsFixed(2)}'),
            Text('Latest: \$${latest.toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Text(
              'Change: $sign${delta.toStringAsFixed(2)} ($sign${percent.toStringAsFixed(2)}%)',
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
            const Divider(height: 24),
            const Text('Points', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...prices.take(12).toList().asMap().entries.map((entry) {
              final i = entry.key;
              final v = entry.value;
              return Text('• ${i + 1}: \$${v.toStringAsFixed(2)}');
            }),
            if (prices.length > 12) const Text('…'),
          ],
        ),
      ),
    );
  }
}
