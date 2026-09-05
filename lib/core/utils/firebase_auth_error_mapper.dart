import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthErrorMapper {
  const FirebaseAuthErrorMapper._();

  static String map(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'user-disabled':
        return 'This account has been disabled. Contact support.';
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'operation-not-allowed':
        return 'This sign-in method is currently disabled.';
      case 'weak-password':
        return 'Please choose a stronger password (at least 6 characters).';
      case 'too-many-requests':
        return 'Too many attempts. Please wait a moment and try again.';
      case 'network-request-failed':
        return 'No internet connection. Please check your network.';
      case 'requires-recent-login':
        return 'Please log in again to complete this action.';
      case 'invalid-action-code':
        return 'This link has expired or has already been used.';
      case 'expired-action-code':
        return 'This link has expired. Please request a new one.';
      case 'user-token-expired':
        return 'Your session has expired. Please log in again.';
      default:
        return e.message ?? 'Something went wrong. Please try again.';
    }
  }
}
