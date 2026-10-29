enum AirtimeNetwork { mtn, airtel, glo, nineMobile }

extension AirtimeNetworkX on AirtimeNetwork {
  String get label {
    switch (this) {
      case AirtimeNetwork.mtn:
        return 'MTN';
      case AirtimeNetwork.airtel:
        return 'Airtel';
      case AirtimeNetwork.glo:
        return 'Glo';
      case AirtimeNetwork.nineMobile:
        return '9mobile';
    }
  }

  String get apiValue {
    switch (this) {
      case AirtimeNetwork.mtn:
        return 'mtn';
      case AirtimeNetwork.airtel:
        return 'airtel';
      case AirtimeNetwork.glo:
        return 'glo';
      case AirtimeNetwork.nineMobile:
        return '9mobile';
    }
  }
}

class AirtimePurchaseRequest {
  final AirtimeNetwork network;
  final String phoneNumber;
  final double amount;

  const AirtimePurchaseRequest({
    required this.network,
    required this.phoneNumber,
    required this.amount,
  });
}

class AirtimePurchaseResult {
  final String reference;
  final bool successful;
  final String message;
  final DateTime createdAt;

  const AirtimePurchaseResult({
    required this.reference,
    required this.successful,
    required this.message,
    required this.createdAt,
  });
}
