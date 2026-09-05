import 'package:firebase_auth/firebase_auth.dart';

import '../utils/firebase_auth_error_mapper.dart';
import '../utils/logger.dart';

class FirebaseAuthService {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthService(this._firebaseAuth);

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<User> login({required String email, required String password}) async {
    Logger.userAction('Login Attempt', data: {'email': email});

    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = credential.user;
      if (user == null) {
        throw Exception('Login failed. Please try again.');
      }
      Logger.success('Login successful for ${user.email}');
      return user;
    } on FirebaseAuthException catch (e) {
      Logger.error('Firebase login failed (${e.code})', error: e);
      throw Exception(FirebaseAuthErrorMapper.map(e));
    }
  }

  Future<User> signUp({
    required String email,
    required String password,
    required String username,
    String? phoneNumber,
    String? referralCode,
  }) async {
    Logger.userAction('Signup Attempt', data: {'email': email});
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = credential.user;
      if (user == null) {
        throw Exception('Registration failed. Please try again.');
      }
      await user.updateDisplayName(username);

      Logger.success('Firebase signup successful for ${user.email}');
      return user;
    } on FirebaseAuthException catch (e) {
      Logger.error('Failed to create account', error: e);
      throw Exception(FirebaseAuthErrorMapper.map(e));
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user == null) {
        throw Exception('No user is currently logged in');
      }
      await user.sendEmailVerification();
      Logger.success('Verification email sent to ${user.email}');
    } on FirebaseAuthException catch (e) {
      Logger.error('Failed to send verification email (${e.code})', error: e);
      throw Exception(FirebaseAuthErrorMapper.map(e));
    }
  }

  Future<bool> refreshEmailVerifiedStatus() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        return false;
      }
      await user.reload();
      final refreshedUser = _firebaseAuth.currentUser;

      Logger.debug(
        'Email verification status refreshed: '
        '${refreshedUser?.emailVerified ?? false}',
      );
      return refreshedUser?.emailVerified ?? false;
    } on FirebaseAuthException catch (e) {
      Logger.error('Failed to refresh user (${e.code})', error: e);
      throw Exception(FirebaseAuthErrorMapper.map(e));
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
      Logger.success('Password reset email sent to $email');
    } on FirebaseAuthException catch (e) {
      Logger.error('Failed to send password reset email (${e.code})', error: e);
      throw Exception(FirebaseAuthErrorMapper.map(e));
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No user is currently logged in.');
      await user.updatePassword(newPassword);
      Logger.success('Password updated');
    } on FirebaseAuthException catch (e) {
      Logger.error('Failed to update password (${e.code})', error: e);
      throw Exception(FirebaseAuthErrorMapper.map(e));
    }
  }

  Future<void> deleteAccount() async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) throw Exception('No user is currently logged in.');
      await user.delete();
      Logger.success('Firebase account deleted');
    } on FirebaseAuthException catch (e) {
      Logger.error('Failed to delete Firebase account (${e.code})', error: e);
      throw Exception(FirebaseAuthErrorMapper.map(e));
    }
  }

  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      Logger.success('Firebase Sign out successful');
    } on FirebaseAuthException catch (e) {
      Logger.error('Firebase sign out failed (${e.code})', error: e);
      throw Exception(FirebaseAuthErrorMapper.map(e));
    }
  }
}
