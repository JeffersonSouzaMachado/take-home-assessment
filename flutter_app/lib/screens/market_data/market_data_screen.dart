import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsenow_flutter/widgets/market/market_data_tile.dart';
import 'package:pulsenow_flutter/widgets/common/error_state.dart';
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
    // TODO: Load market data when screen initializes
    // Provider.of<MarketDataProvider>(context, listen: false).loadMarketData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MarketDataProvider>(context, listen: false).loadMarketData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MarketDataProvider>(
      builder: (context, provider, child) {
        // TODO: Implement the UI
        // Show loading indicator when provider.isLoading is true
        // Show error message when provider.error is not null
        // Show list of market data when provider.marketData is available
        // Each list item should show:
        //   - Symbol (e.g., "BTC/USD")
        //   - Price (formatted as currency)
        //   - 24h change (with color: green for positive, red for negative)
        // Implement pull-to-refresh using RefreshIndicator

        final data = provider.marketData;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Market Data'),
            actions: [
              IconButton(
                tooltip: 'Refresh',
                onPressed: provider.isLoading
                    ? null
                    : () => provider.loadMarketData(),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: Builder(
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
                    Center(child: Text('No market data available.')),
                  ],
                )
                    : ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: data.length,
                  separatorBuilder: (_, __) =>
                  const Divider(height: 1),
                  itemBuilder: (context, index) {
                    return MarketDataTile(item: data[index]);
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }
}
