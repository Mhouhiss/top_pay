import '../../bills/model/airtime_purchase_model.dart';

class DataBundleModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String validity;

  const DataBundleModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.validity,
  });
}

class DataPurchaseRequest {
  final AirtimeNetwork network;
  final String phoneNumber;
  final DataBundleModel bundle;

  const DataPurchaseRequest({
    required this.network,
    required this.phoneNumber,
    required this.bundle,
  });
}

class DataPurchaseResult {
  final String reference;
  final bool successful;
  final String message;
  final DateTime createdAt;

  const DataPurchaseResult({
    required this.reference,
    required this.successful,
    required this.message,
    required this.createdAt,
  });
}
