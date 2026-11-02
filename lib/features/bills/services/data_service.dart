import 'package:flutter/foundation.dart';

import '../../bills/model/airtime_purchase_model.dart';
import '../../bills/model/data_bundle_model.dart';

class DataService {
  // Development-only mock balance. Replace with the actual wallet API/state.
  Future<double> getWalletBalance() async {
    await Future.delayed(const Duration(milliseconds: 400));

    // REAL API EXAMPLE (adapt to your confirmed backend response):
    // final response = await apiService.get(ApiEndpoints.walletBalance);
    // return (response.data['balance'] as num).toDouble();

    return 74850.50;
  }

  Future<List<DataBundleModel>> getBundles(AirtimeNetwork network) async {
    await Future.delayed(const Duration(milliseconds: 450));

    // REAL API EXAMPLE:
    // final response = await apiService.get(
    //   ApiEndpoints.dataBundles,
    //   queryParameters: {'network': network.apiValue},
    // );
    // return (response.data['bundles'] as List)
    //     .map((item) => DataBundleModel.fromJson(item))
    //     .toList();

    // Dummy catalog for layout and flow testing only.
    switch (network) {
      case AirtimeNetwork.mtn:
        return const [
          DataBundleModel(
            id: 'mtn-500mb',
            name: '500 MB',
            description: 'Daily plan',
            price: 150,
            validity: '1 day',
          ),
          DataBundleModel(
            id: 'mtn-1gb',
            name: '1 GB',
            description: 'Weekly plan',
            price: 500,
            validity: '7 days',
          ),
          DataBundleModel(
            id: 'mtn-2gb',
            name: '2 GB',
            description: 'Monthly plan',
            price: 1200,
            validity: '30 days',
          ),
          DataBundleModel(
            id: 'mtn-5gb',
            name: '5 GB',
            description: 'Monthly plan',
            price: 2500,
            validity: '30 days',
          ),
        ];
      case AirtimeNetwork.airtel:
        return const [
          DataBundleModel(
            id: 'airtel-500mb',
            name: '500 MB',
            description: 'Daily plan',
            price: 150,
            validity: '1 day',
          ),
          DataBundleModel(
            id: 'airtel-1gb',
            name: '1 GB',
            description: 'Weekly plan',
            price: 500,
            validity: '7 days',
          ),
          DataBundleModel(
            id: 'airtel-2gb',
            name: '2 GB',
            description: 'Monthly plan',
            price: 1200,
            validity: '30 days',
          ),
          DataBundleModel(
            id: 'airtel-5gb',
            name: '5 GB',
            description: 'Monthly plan',
            price: 2500,
            validity: '30 days',
          ),
        ];
      case AirtimeNetwork.glo:
        return const [
          DataBundleModel(
            id: 'glo-500mb',
            name: '500 MB',
            description: 'Daily plan',
            price: 100,
            validity: '1 day',
          ),
          DataBundleModel(
            id: 'glo-1gb',
            name: '1 GB',
            description: 'Weekly plan',
            price: 450,
            validity: '7 days',
          ),
          DataBundleModel(
            id: 'glo-2gb',
            name: '2 GB',
            description: 'Monthly plan',
            price: 1000,
            validity: '30 days',
          ),
          DataBundleModel(
            id: 'glo-5gb',
            name: '5 GB',
            description: 'Monthly plan',
            price: 2500,
            validity: '30 days',
          ),
        ];
      case AirtimeNetwork.nineMobile:
        return const [
          DataBundleModel(
            id: '9mobile-500mb',
            name: '500 MB',
            description: 'Daily plan',
            price: 100,
            validity: '1 day',
          ),
          DataBundleModel(
            id: '9mobile-1gb',
            name: '1 GB',
            description: 'Weekly plan',
            price: 500,
            validity: '7 days',
          ),
          DataBundleModel(
            id: '9mobile-2gb',
            name: '2 GB',
            description: 'Monthly plan',
            price: 1000,
            validity: '30 days',
          ),
          DataBundleModel(
            id: '9mobile-5gb',
            name: '5 GB',
            description: 'Monthly plan',
            price: 2500,
            validity: '30 days',
          ),
        ];
    }
  }

  Future<DataPurchaseResult> purchaseData({
    required DataPurchaseRequest request,
    required String transactionPin,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    // REAL API EXAMPLE (adapt to your confirmed backend contract):
    // final response = await apiService.post(
    //   ApiEndpoints.dataPurchase,
    //   data: {
    //     'network': request.network.apiValue,
    //     'phoneNumber': request.phoneNumber,
    //     'bundleCode': request.bundle.id,
    //     'amount': request.bundle.price,
    //     'pin': transactionPin,
    //   },
    // );
    // Parse the response into DataPurchaseResult here.

    if (kDebugMode) {
      debugPrint(
        'DUMMY DATA PURCHASE: ${request.network.apiValue}, '
        '${request.phoneNumber}, ${request.bundle.id}, '
        '${request.bundle.price}',
      );
    }

    return DataPurchaseResult(
      reference: 'TPDATA${DateTime.now().millisecondsSinceEpoch}',
      successful: true,
      message: 'Data bundle purchase completed successfully.',
      createdAt: DateTime.now(),
    );
  }
}
