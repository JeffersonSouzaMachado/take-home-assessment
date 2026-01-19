import 'package:flutter/material.dart';

import '../../models/analytics/analytics_overview_model.dart';
import 'key_value_row.dart';

class OverviewCard extends StatelessWidget {
  const OverviewCard({super.key, required this.data});

  final AnalyticsOverview data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            KeyValueRow(label: 'Total Market Cap', value: _formatCurrency(data.totalMarketCap)),
            const SizedBox(height: 8),
            KeyValueRow(label: 'Total Volume (24h)', value: _formatCurrency(data.totalVolume24h)),
            const SizedBox(height: 8),
            KeyValueRow(label: 'Active Markets', value: data.activeMarkets.toString()),
            const Divider(height: 24),

            _LeaderRow(
              title: 'Top Gainer',
              symbol: data.topGainer.symbol,
              price: _formatCurrency(data.topGainer.price),
              changePercent: data.topGainer.changePercent24h,
            ),
            const SizedBox(height: 12),
            _LeaderRow(
              title: 'Top Loser',
              symbol: data.topLoser.symbol,
              price: _formatCurrency(data.topLoser.price),
              changePercent: data.topLoser.changePercent24h,
            ),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double value) => '\$${value.toStringAsFixed(2)}';
}

class _LeaderRow extends StatelessWidget {
  const _LeaderRow({
    required this.title,
    required this.symbol,
    required this.price,
    required this.changePercent,
  });

  final String title;
  final String symbol;
  final String price;
  final double changePercent;

  @override
  Widget build(BuildContext context) {
    final isPositive = changePercent >= 0;
    final sign = isPositive ? '+' : '';
    final color = isPositive ? Colors.green : Colors.red;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        Text(symbol),
        const SizedBox(width: 12),
        Text(price),
        const SizedBox(width: 12),
        Text(
          '$sign${changePercent.toStringAsFixed(2)}%',
          style: TextStyle(color: color, fontWeight: FontWeight.w700),
        ),
      ],
    );
  }
}
