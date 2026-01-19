import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsenow_flutter/theme/app_theme.dart';

import 'screens/home_screen.dart';
import 'providers/market_data_provider.dart';
import 'providers/analytics_provider.dart';
import 'providers/portfolio_provider.dart';

void main() {
  runApp(const PulseNowApp());
}

class PulseNowApp extends StatelessWidget {
  const PulseNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MarketDataProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
      ],
      child: MaterialApp(
        title: 'PulseNow',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
