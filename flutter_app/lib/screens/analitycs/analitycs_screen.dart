import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsenow_flutter/widgets/analitycs/overview_card.dart';
import 'package:pulsenow_flutter/widgets/analitycs/section_title.dart';
import 'package:pulsenow_flutter/widgets/analitycs/sentiment_card.dart';
import 'package:pulsenow_flutter/widgets/analitycs/trends_card.dart';

import '../../providers/analytics_provider.dart';
import '../../widgets/common/error_state.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  String _timeframe = '24h';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _reload();
    });
  }

  Future<void> _reload() async {
    final provider = context.read<AnalyticsProvider>();
    await provider.loadOverview();
    await provider.loadTrends(_timeframe);
    await provider.loadSentiment();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AnalyticsProvider>(
      builder: (context, provider, _) {
        final isLoading = provider.isLoading;
        final error = provider.error;

        final overview = provider.overview;
        final trends = provider.trends;
        final sentiment = provider.sentiment;

        return Scaffold(
          appBar: AppBar(
            title: const Text('Analytics'),
            actions: [
              IconButton(
                onPressed: isLoading ? null : _reload,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          body: Builder(
            builder: (_) {
              final isInitialLoading = isLoading &&
                  overview == null &&
                  trends == null &&
                  sentiment == null;

              if (isInitialLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (error != null &&
                  overview == null &&
                  trends == null &&
                  sentiment == null) {
                return ErrorState(
                  title: 'Unable to load analytics',
                  message: error,
                  onRetry: _reload,
                );
              }

              return RefreshIndicator(
                onRefresh: _reload,
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    const SectionTitle(title: 'Overview'),
                    if (overview != null)
                      OverviewCard(data: overview)
                    else
                      const Card(
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No overview data.'))),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(child: SectionTitle(title: 'Trends')),
                        DropdownButton<String>(
                          value: _timeframe,
                          items: const [
                            DropdownMenuItem(value: '24h', child: Text('24h')),
                            DropdownMenuItem(value: '7d', child: Text('7d')),
                            DropdownMenuItem(value: '30d', child: Text('30d')),
                          ],
                          onChanged: isLoading
                              ? null
                              : (v) async {
                                  if (v == null) return;
                                  setState(() => _timeframe = v);
                                  await context
                                      .read<AnalyticsProvider>()
                                      .loadTrends(v);
                                },
                        ),
                      ],
                    ),
                    if (trends != null)
                      TrendsCard(data: trends)
                    else
                      const Card(
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No trends data.'))),
                    const SizedBox(height: 16),
                    const SectionTitle(title: 'Sentiment'),
                    if (sentiment != null)
                      SentimentCard(data: sentiment)
                    else
                      const Card(
                          child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text('No sentiment data.'))),
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
