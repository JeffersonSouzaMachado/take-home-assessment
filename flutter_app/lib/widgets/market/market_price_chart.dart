import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pulsenow_flutter/models/market_history_point.dart';

class MarketPriceChart extends StatelessWidget {
  const MarketPriceChart({
    super.key,
    required this.points,
  });

  final List<MarketHistoryPoint> points;

  @override
  Widget build(BuildContext context) {
    if (points.isEmpty) {
      return const SizedBox(
        height: 220,
        child: Center(child: Text('No chart data')),
      );
    }

    // transforma em spots (x = índice, y = preço)
    final spots = <FlSpot>[
      for (int i = 0; i < points.length; i++)
        FlSpot(i.toDouble(), points[i].price),
    ];

    final minY = points.map((e) => e.price).reduce((a, b) => a < b ? a : b);
    final maxY = points.map((e) => e.price).reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 220,
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          gridData: const FlGridData(show: true),
          borderData: FlBorderData(show: false),
          titlesData: const FlTitlesData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              barWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
