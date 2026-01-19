
import 'package:pulsenow_flutter/models/portfolio/portfolio_transaction_request.dart';

class TransactionTypeMapper {
  static TransactionType fromString(String value) {
    switch (value.toLowerCase()) {
      case 'buy':
        return TransactionType.buy;
      case 'sell':
        return TransactionType.sell;
      default:
        throw ArgumentError('Invalid transaction type: $value');
    }
  }

  static String toStringValue(TransactionType type) {
    return type.name;
  }
}
