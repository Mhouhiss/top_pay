class UserModel {
  final String id;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String? photoUrl;
  final bool isEmailVerified;
  final bool hasTransactionPin;
  final bool biometricEnabled;
  final DateTime createdAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    this.photoUrl,
    this.isEmailVerified = false,
    this.hasTransactionPin = false,
    this.biometricEnabled = false,
    required this.createdAt,
  });

  String get initials {
    final parts = fullName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return (parts.first.substring(0, 1) + parts.last.substring(0, 1))
        .toUpperCase();
  }

  UserModel copyWith({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? photoUrl,
    bool? isEmailVerified,
    bool? hasTransactionPin,
    bool? biometricEnabled,
  }) {
    return UserModel(
      id: id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoUrl: photoUrl ?? this.photoUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      hasTransactionPin: hasTransactionPin ?? this.hasTransactionPin,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      createdAt: createdAt,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      photoUrl: json['photoUrl'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      hasTransactionPin: json['hasTransactionPin'] as bool? ?? false,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'isEmailVerified': isEmailVerified,
      'hasTransactionPin': hasTransactionPin,
      'biometricEnabled': biometricEnabled,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
