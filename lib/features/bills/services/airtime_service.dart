import 'package:flutter/foundation.dart';

import '../model/airtime_purchase_model.dart';
import '../../../core/utils/logger.dart';

class AirtimeService {
  // Development-only mock balance.
  Future<double> getWalletBalance() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // REAL API IMPLEMENTATION
    // final response = await apiService.get(ApiEndpoints.walletBalance);
    // return (response.data['balance'] as num).toDouble();

    return 74850.50;
  }

  Future<AirtimePurchaseResult> purchaseAirtime({
    required AirtimePurchaseRequest request,
    required String transactionPin,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // REAL API IMPLEMENTATION
    // final response = await apiService.post(
    //   ApiEndpoints.airtimePurchase,
    //   data: {
    //     'network': request.network.apiValue,
    //     'phoneNumber': request.phoneNumber,
    //     'amount': request.amount,
    //     'pin': transactionPin,
    //   },
    // );
    // return AirtimePurchaseResult(
    //   reference: response.data['reference'],
    //   successful: response.data['status'] == 'successful',
    //   message: response.data['message'] ?? 'Airtime purchase completed.',
    //   createdAt: DateTime.now(),
    // );

    // Dummy response only; do not use as real transaction security.
    if (kDebugMode) {
      Logger.info(
        'DUMMY AIRTIME PURCHASE: ${request.network.apiValue}, '
        '${request.phoneNumber}, ${request.amount}',
      );
    }

    return AirtimePurchaseResult(
      reference: 'TP${DateTime.now().millisecondsSinceEpoch}',
      successful: true,
      message: 'Airtime purchase completed successfully.',
      createdAt: DateTime.now(),
    );
  }
}
