import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsenow_flutter/widgets/market/market_data_tile.dart';
import 'package:pulsenow_flutter/widgets/common/error_state.dart';
import 'package:pulsenow_flutter/widgets/market/market_price_chart.dart';
import 'package:pulsenow_flutter/widgets/market/time_fram_button.dart';
import '../../providers/market_data_provider.dart';

class MarketDataScreen extends StatefulWidget {
  const MarketDataScreen({super.key});

  @override
  State<MarketDataScreen> createState() => _MarketDataScreenState();
}

class _MarketDataScreenState extends State<MarketDataScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MarketDataProvider>(context, listen: false);
      provider.loadMarketData();
      provider.startRealtimeUpdates();
    });
  }

  @override
  void dispose() {
    Provider.of<MarketDataProvider>(context, listen: false)
        .stopRealtimeUpdates();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketDataProvider>(
      builder: (context, provider, child) {
        final data = provider.marketData;

        return Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Market date',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          IconButton(
                              onPressed: () => provider.toggleRealtimeUpdates(),
                              icon: provider.isRealtimeEnabled
                                  ? (provider.isRealtimeConnected
                                      ? const Icon(
                                          Icons.wifi,
                                          color: Colors.green,
                                        )
                                      : const Icon(
                                          Icons.wifi_tethering_error,
                                          color: Colors.yellow,
                                        ))
                                  : const Icon(
                                      Icons.wifi_off,
                                      color: Colors.red,
                                    )),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Container(
                          width: double.infinity,
                          height: 300,
                          decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20))),
                          child: provider.isHistoryLoading
                              ? const Center(child: CircularProgressIndicator())
                              : MarketPriceChart(
                                  points: provider.selectedHistory),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TimeframeButton(
                            label: '1H',
                            value: '1h',
                            selected: provider.selectedTimeframe == '1h',
                            onTap: () => provider.setTimeframe('1h'),
                          ),
                          const SizedBox(width: 8),
                          TimeframeButton(
                            label: '24H',
                            value: '24h',
                            selected: provider.selectedTimeframe == '24h',
                            onTap: () => provider.setTimeframe('24h'),
                          ),
                          const SizedBox(width: 8),
                          TimeframeButton(
                            label: '1M',
                            value: '1m',
                            selected: provider.selectedTimeframe == '1m',
                            onTap: () => provider.setTimeframe('1m'),
                          ),
                          const SizedBox(width: 8),
                          TimeframeButton(
                            label: '1Y',
                            value: '1y',
                            selected: provider.selectedTimeframe == '1y',
                            onTap: () => provider.setTimeframe('1y'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Builder(
                    builder: (_) {
                      if (provider.isLoading && data.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (provider.error != null && data.isEmpty) {
                        return ErrorState(
                          message: provider.error!,
                          onRetry: () => provider.loadMarketData(),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () => provider.loadMarketData(),
                        child: data.isEmpty
                            ? ListView(
                                physics: const AlwaysScrollableScrollPhysics(),
                                children: const [
                                  SizedBox(height: 160),
                                  Center(
                                      child: Text('No market data available.')),
                                ],
                              )
                            : ListView.builder(
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount: data.length,
                                itemBuilder: (context, index) {
                                  final item = data[index];
                                  return InkWell(
                                    onTap: () =>
                                        provider.selectSymbol(item.symbol),
                                    child: MarketDataTile(item: item),
                                  );
                                },
                              ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
