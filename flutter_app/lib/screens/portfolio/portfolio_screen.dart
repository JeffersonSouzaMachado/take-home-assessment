import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/portfolio_provider.dart';
import '../../widgets/common/error_state.dart';
import '../../widgets/portfolio/portfolio_summary_card.dart';
import '../../widgets/portfolio/portfolio_performance_card.dart';
import '../../widgets/portfolio/portfolio_holding_tile.dart';
import '../../widgets/portfolio/timeframe_selector.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  String _timeframe = '24h';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _reload();
    });
  }

  Future<void> _reload() async {
    final provider = context.read<PortfolioProvider>();
    await provider.loadPortfolioSummary();
    await provider.loadHoldings();
    await provider.loadPerformance(_timeframe);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PortfolioProvider>(
      builder: (context, provider, _) {
        final isLoading = provider.isLoading;
        final error = provider.error;

        final summary = provider.summary;
        final performance = provider.performance;
        final holdings = provider.holdings;

        final isInitialLoading = isLoading && summary == null && holdings.isEmpty && performance == null;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Portfolio'),
            actions: [
              IconButton(
                onPressed: isLoading ? null : _reload,
                icon: const Icon(Icons.refresh),
                tooltip: 'Refresh',
              ),
            ],
          ),
          body: Builder(
            builder: (_) {
              if (isInitialLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (error != null && summary == null && holdings.isEmpty && performance == null) {
                return ErrorState(
                  title: 'Unable to load portfolio',
                  message: error,
                  onRetry: _reload,
                );
              }

              return RefreshIndicator(
                onRefresh: _reload,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    if (summary != null)
                      PortfolioSummaryCard(summary: summary)
                    else
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No summary data.'),
                        ),
                      ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                        ),
                        TimeframeSelector(
                          value: _timeframe,
                          isDisabled: isLoading,
                          onChanged: (v) async {
                            setState(() => _timeframe = v);
                            await context.read<PortfolioProvider>().loadPerformance(v);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (performance != null)
                      PortfolioPerformanceCard(performance: performance)
                    else
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No performance data.'),
                        ),
                      ),

                    const SizedBox(height: 16),
                    const Text('Holdings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),

                    if (holdings.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('No holdings available.'),
                        ),
                      )
                    else
                      ...holdings.map((h) => PortfolioHoldingTile(holding: h)),

                    if (error != null) ...[
                      const SizedBox(height: 16),
                      Text(error, style: const TextStyle(color: Colors.red)),
                    ],
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
