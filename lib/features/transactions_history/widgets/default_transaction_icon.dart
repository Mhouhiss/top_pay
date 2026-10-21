import 'package:top_pay/core/constants/app_assets.dart';
import 'package:top_pay/features/transactions_history/model/transaction_model.dart';

String transactionIcon(TransactionModel transaction) {
  switch (transaction.type.toLowerCase().trim()) {
    case 'airtime':
      return AppAssets.airtime;

    case 'data':
      return AppAssets.data;

    case 'electricity':
      return AppAssets.electricity;

    case 'cabletv':
      return AppAssets.tv;

    case 'education':
      return AppAssets.education;

    case 'betting':
      return AppAssets.betting;

    case 'funding':
      return AppAssets.funding;

    case 'card':
      return AppAssets.card;

    default:
      return AppAssets.wallet;
  }
}
