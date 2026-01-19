import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pulsenow_flutter/controller/portfolio/add_transaction_controller.dart';

import '../../../utils/form_validators.dart';
import '../../../utils/portfolio_symbols.dart';

class AddTransactionForm extends StatelessWidget {
  const AddTransactionForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AddTransactionController>(
      builder: (_, controller, __) {
        return Form(
          key: controller.formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              const Text(
                'Transaction Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: controller.symbol,
                decoration: const InputDecoration(
                  labelText: 'Symbol',
                  border: OutlineInputBorder(),
                ),
                items: PortfolioSymbols.supported
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: controller.isSubmitting ? null : (v) => controller.setSymbol(v ?? controller.symbol),
              ),
              const SizedBox(height: 12),

              DropdownButtonFormField<String>(
                value: controller.type,
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: 'buy', child: Text('Buy')),
                  DropdownMenuItem(value: 'sell', child: Text('Sell')),
                ],
                onChanged: controller.isSubmitting ? null : (v) => controller.setType(v ?? controller.type),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: controller.quantityController,
                enabled: !controller.isSubmitting,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'e.g., 0.05',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => FormValidators.requiredPositiveDouble(v, fieldName: 'Quantity'),
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: controller.priceController,
                enabled: !controller.isSubmitting,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'e.g., 43000',
                  border: OutlineInputBorder(),
                ),
                validator: (v) => FormValidators.requiredPositiveDouble(v, fieldName: 'Price'),
              ),
              const SizedBox(height: 16),

              FilledButton.icon(
                onPressed: controller.isSubmitting
                    ? null
                    : () async {
                  try {
                    final ok = await controller.submit();
                    if (!ok) return;

                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Transaction added successfully.')),
                    );
                    Navigator.of(context).pop(true);
                  } catch (e) {
                    if (!context.mounted) return;
                    final message = controller.mapErrorToUserMessage(e);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                  }
                },
                icon: controller.isSubmitting
                    ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Icon(Icons.check),
                label: Text(controller.isSubmitting ? 'Submitting...' : 'Submit'),
              ),
            ],
          ),
        );
      },
    );
  }
}
