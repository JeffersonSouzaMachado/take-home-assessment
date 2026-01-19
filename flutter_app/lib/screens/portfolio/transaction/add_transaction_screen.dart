import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsenow_flutter/controller/portfolio/add_transaction_controller.dart';
import 'package:pulsenow_flutter/screens/portfolio/transaction/transaction_form.dart';

import '../../../providers/portfolio_provider.dart';

class AddTransactionScreen extends StatelessWidget {
  const AddTransactionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolioProvider = context.read<PortfolioProvider>();

    return ChangeNotifierProvider(
      create: (_) => AddTransactionController(portfolioProvider: portfolioProvider),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add Transaction'),
        ),
        body: const SafeArea(
          child: AddTransactionForm(),
        ),
      ),
    );
  }
}
