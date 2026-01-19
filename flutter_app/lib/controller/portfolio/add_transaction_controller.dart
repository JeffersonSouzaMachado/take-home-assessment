import 'package:flutter/material.dart';
import 'package:pulsenow_flutter/models/portfolio/portfolio_transaction_request.dart';
import 'package:pulsenow_flutter/utils/transaction_type_mapper.dart';

import '../../providers/portfolio_provider.dart';
import '../../utils/form_validators.dart';
import '../../utils/portfolio_symbols.dart';

class AddTransactionController extends ChangeNotifier {
  AddTransactionController({required this.portfolioProvider});

  final PortfolioProvider portfolioProvider;

  final formKey = GlobalKey<FormState>();

  String symbol = PortfolioSymbols.supported.first;
  String type = 'buy';

  final TextEditingController quantityController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  bool isSubmitting = false;

  @override
  void dispose() {
    quantityController.dispose();
    priceController.dispose();
    super.dispose();
  }

  void setSymbol(String value) {
    symbol = value;
    notifyListeners();
  }

  void setType(String value) {
    type = value;
    notifyListeners();
  }

  String mapErrorToUserMessage(Object error) {
    final msg = error.toString();
    if (msg.startsWith('Exception: ')) {
      final cleaned = msg.replaceFirst('Exception: ', '').trim();
      if (cleaned.isNotEmpty) return cleaned;
    }
    return 'Unable to add transaction. Please try again.';
  }

  Future<bool> submit() async {
    final ok = formKey.currentState?.validate() ?? false;
    if (!ok) return false;

    final quantity = FormValidators.parseDouble(quantityController.text);
    final price = FormValidators.parseDouble(priceController.text);

    isSubmitting = true;
    notifyListeners();

    if (!PortfolioSymbols.isSupported(symbol)) {
      throw ArgumentError('Unsupported symbol: $symbol');
    }

    try {
      final request = PortfolioTransactionRequest(
        symbol: symbol,
        type: TransactionTypeMapper.fromString(type),
        quantity: quantity,
        price: price,
      );

      await portfolioProvider.addTransaction(request);

      return true;
    } catch (e, stackTrace) {
      debugPrint('AddTransactionController.submit failed: $e');
      debugPrintStack(stackTrace: stackTrace);
      rethrow;
    } finally {
      isSubmitting = false;
      notifyListeners();
    }
  }


}
