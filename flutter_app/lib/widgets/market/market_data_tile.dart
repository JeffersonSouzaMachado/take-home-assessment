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
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        width: size.width,
        height: 80,
        decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.3),
            borderRadius: const BorderRadius.all(Radius.circular(20))),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 5,
                children: [
                  Text(
                    item.symbol,
                      style: Theme.of(context).textTheme.titleLarge
                  ),
                  Text('Volume: ${item.volume.toStringAsFixed(0)}'),
                ],
              ),
              const Spacer(),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _formatCurrency(item.price),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    '$sign${item.change24h.toStringAsFixed(2)} '
                        '($sign${item.changePercent24h.toStringAsFixed(2)}%)',
                    style: TextStyle(
                      color: changeColor,
                      fontWeight: FontWeight.w600,
                    )),
                ],
              )
            ],
          ),
        ),
      ),
    );



  }

  String _formatCurrency(double value) {
    return '\$${value.toStringAsFixed(2)}';
  }
}
