import 'package:flutter/material.dart';

import '../../models/analytics/analytics_sentiment_model.dart';

class SentimentCard extends StatelessWidget {
  const SentimentCard({super.key, required this.data});

  final AnalyticsSentiment data;

  @override
  Widget build(BuildContext context) {
    final total = data.positive + data.neutral + data.negative;
    final safeTotal = total == 0 ? 1.0 : total;

    final positivePct = (data.positive / safeTotal) * 100;
    final neutralPct = (data.neutral / safeTotal) * 100;
    final negativePct = (data.negative / safeTotal) * 100;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SentimentRow(label: 'Positive', value: positivePct),
            const SizedBox(height: 10),
            _SentimentRow(label: 'Neutral', value: neutralPct),
            const SizedBox(height: 10),
            _SentimentRow(label: 'Negative', value: negativePct),
          ],
        ),
      ),
    );
  }
}

class _SentimentRow extends StatelessWidget {
  const _SentimentRow({required this.label, required this.value});

  final String label;
  final double value;

  @override
  Widget build(BuildContext context) {
    final pctText = '${value.toStringAsFixed(1)}%';

    return Row(
      children: [
        SizedBox(width: 80, child: Text(label)),
        Expanded(
          child: LinearProgressIndicator(
            value: (value / 100).clamp(0, 1),
            minHeight: 10,
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(width: 60, child: Text(pctText, textAlign: TextAlign.right)),
      ],
    );
  }
}
