enum TransactionStatus { successful, pending, reversed, failed }

class TransactionModel {
  const TransactionModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.createdAt,
    required this.status,
    required this.type,
    required this.reference,
    this.userId,
    this.phoneNumber,
    this.bundleCode,
  });

  final String id;
  final String description;
  final double amount;
  final DateTime createdAt;
  final TransactionStatus status;
  final String type;
  final String reference;
  final String? userId;
  final String? phoneNumber;
  final String? bundleCode;

  bool get isSuccessful => status == TransactionStatus.successful;

  bool get isPending => status == TransactionStatus.pending;

  bool get isReversed => status == TransactionStatus.reversed;

  bool get isFailed => status == TransactionStatus.failed;

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      status: TransactionStatus.values.byName(json['status'] as String),
      type: json['type'] as String,
      reference: json['reference'] as String,
      userId: json['userId'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      bundleCode: json['bundleCode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'amount': amount,
      'createdAt': createdAt.toIso8601String(),
      'status': status.name,
      'type': type,
      'reference': reference,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'bundleCode': bundleCode,
    };
  }

  String get statusLabel {
    switch (status) {
      case TransactionStatus.successful:
        return 'Successful';
      case TransactionStatus.pending:
        return 'Pending';
      case TransactionStatus.reversed:
        return 'Reversed';
      case TransactionStatus.failed:
        return 'Failed';
    }
  }

  String get displayTitle {
    switch (type.toLowerCase()) {
      case 'airtime':
        return 'Airtime Purchase';
      case 'data':
        return 'Data Purchase';
      case 'cabletv':
        return 'Cable TV';
      case 'electricity':
        return 'Electricity Bill';
      case 'education':
        return 'Education Payment';
      case 'betting':
        return 'Betting Payment';
      case 'funding':
        return 'Wallet Funding';
      case 'card':
        return 'Card Payment';
      default:
        return description;
    }
  }
}
