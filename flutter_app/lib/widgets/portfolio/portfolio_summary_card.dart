import 'package:flutter/material.dart';
import '../../models/portfolio/portfolio_summary_model.dart';

class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({super.key, required this.summary});

  final PortfolioSummary summary;

  @override
  Widget build(BuildContext context) {
    final pnlPositive = summary.totalPnl >= 0;
    final pnlSign = pnlPositive ? '+' : '';
    final pnlColor = pnlPositive ? Colors.green : Colors.red;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _Row(label: 'Total Value', value: _formatCurrency(summary.totalValue)),
            const SizedBox(height: 8),
            _Row(
              label: 'PnL',
              value: '$pnlSign${_formatCurrency(summary.totalPnl)}',
              valueStyle: TextStyle(color: pnlColor, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            _Row(
              label: 'PnL %',
              value: '$pnlSign${summary.totalPnlPercent.toStringAsFixed(2)}%',
              valueStyle: TextStyle(color: pnlColor, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatCurrency(double value) => '\$${value.toStringAsFixed(2)}';
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value, this.valueStyle});

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: valueStyle ?? const TextStyle(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
