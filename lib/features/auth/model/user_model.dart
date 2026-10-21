import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? phoneNumber;
  final String? photoUrl;
  final bool emailVerified;
  final DateTime? createdAt;

  const UserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.phoneNumber,
    this.photoUrl,
    this.emailVerified = false,
    this.createdAt,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      phoneNumber: user.phoneNumber,
      photoUrl: user.photoURL,
      emailVerified: user.emailVerified,
      createdAt: user.metadata.creationTime,
    );
  }

  UserModel copyWith({
    String? email,
    String? displayName,
    String? phoneNumber,
    String? photoUrl,
    bool? emailVerified,
    DateTime? createdAt,
    bool clearDisplayName = false,
    bool clearPhoneNumber = false,
    bool clearPhotoUrl = false,
  }) {
    return UserModel(
      uid: uid,
      email: email ?? this.email,
      displayName: clearDisplayName ? null : displayName ?? this.displayName,
      phoneNumber: clearPhoneNumber ? null : phoneNumber ?? this.phoneNumber,
      photoUrl: clearPhotoUrl ? null : photoUrl ?? this.photoUrl,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'photoUrl': photoUrl,
      'emailVerified': emailVerified,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
