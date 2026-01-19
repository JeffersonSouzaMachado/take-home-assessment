import 'package:flutter/material.dart';
import '../../models/portfolio/portfolio_performance_model.dart';

class PortfolioPerformanceCard extends StatelessWidget {
  const PortfolioPerformanceCard({
    super.key,
    required this.performance,
  });

  final PortfolioPerformance performance;

  @override
  Widget build(BuildContext context) {
    final points = performance.values;

    if (points.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('No performance data available.'),
        ),
      );
    }

    final first = points.first;
    final latest = points.last;
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
            Text('Timeframe: ${performance.timeframe}', style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Text('Start: ${_formatCurrency(first)}'),
            Text('Latest: ${_formatCurrency(latest)}'),
            const SizedBox(height: 8),
            Text(
              'Change: $sign${delta.toStringAsFixed(2)} ($sign${percent.toStringAsFixed(2)}%)',
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
            const Divider(height: 24),
            const Text('Points', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...points.take(12).toList().asMap().entries.map((e) {
              final i = e.key;
              final v = e.value;
              return Text('• ${i + 1}: ${_formatCurrency(v)}');
            }),
            if (points.length > 12) const Text('…'),
          ],
        ),
      ),
    );
  }

  static String _formatCurrency(double value) => '\$${value.toStringAsFixed(2)}';
}
