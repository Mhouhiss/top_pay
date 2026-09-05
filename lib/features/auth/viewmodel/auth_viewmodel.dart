import 'dart:async';

import 'package:flutter_riverpod/legacy.dart';

import '../../../core/providers/firebase_provider.dart';
import '../../../core/providers/storage_service_provider.dart';
import '../../../core/services/firebase_auth_service.dart';
import '../../../core/services/local_storage_service.dart';
import '../../../core/utils/logger.dart';
import '../../../features/auth/model/user_model.dart';
import 'auth_state.dart';

class AuthViewModel extends StateNotifier<AuthState> {
  final FirebaseAuthService _authService;
  final LocalStorageService _storage;

  bool _isDisposed = false;

  AuthViewModel(this._authService, this._storage) : super(const AuthState());

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  void _safeSetState(AuthState newState) {
    if (!_isDisposed && mounted) {
      state = newState;
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (_isDisposed) return;
    Logger.userAction('Login Attempt');
    _safeSetState(state.copyWith(isLoading: true, clearError: true));

    try {
      final user = await _authService.login(email: email, password: password);

      final userModel = UserModel.fromFirebaseUser(user);

      _safeSetState(
        state.copyWith(user: userModel, isLoading: false, clearError: true),
      );

      Logger.success('Login successful for ${userModel.email}');
    } catch (e) {
      Logger.error('Login error', error: e);
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: _formatError(e)),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String username,
    String? phoneNumber,
    String? referralCode,
  }) async {
    if (_isDisposed) return;
    Logger.userAction('Sign up attempt');
    _safeSetState(state.copyWith(isLoading: true, clearError: true));

    try {
      final user = await _authService.signUp(
        email: email,
        password: password,
        username: username,
      );

      final userModel = UserModel.fromFirebaseUser(user);

      _safeSetState(
        state.copyWith(
          isLoading: false,
          user: userModel,
          status: AuthStatus.unauthenticated,
          clearError: true,
        ),
      );

      Logger.success('Sign up successful for ${userModel.email}');
    } catch (e) {
      Logger.error('Registration failed', error: e);
      _safeSetState(
        state.copyWith(
          isLoading: false,
          status: AuthStatus.unauthenticated,
          errorMessage: _formatError(e),
        ),
      );
    }
  }

  Future<bool> sendVerificationEmail() async {
    if (_isDisposed) return false;
    Logger.userAction('Send verification Email');
    _safeSetState(state.copyWith(isLoading: true, clearError: true));

    try {
      await _authService.sendEmailVerification();

      _safeSetState(state.copyWith(isLoading: false, clearError: true));
      Logger.success('Verification email sent');
      return true;
    } catch (e) {
      Logger.error('Failed to send verification email', error: e);
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: _formatError(e)),
      );
      return false;
    }
  }

  Future<bool> verifyEmail() async {
    if (_isDisposed) return false;
    Logger.userAction('Verify Email');
    _safeSetState(state.copyWith(isLoading: true, clearError: true));

    try {
      final isVerified = await _authService.refreshEmailVerifiedStatus();

      if (!isVerified) {
        _safeSetState(
          state.copyWith(
            isLoading: false,
            errorMessage: 'Please verify your email first',
          ),
        );
        return false;
      }

      _safeSetState(state.copyWith(isLoading: false, clearError: true));
      Logger.success('Email verified');
      return true;
    } catch (e) {
      Logger.error('Failed to verify email', error: e);
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: _formatError(e)),
      );
      return false;
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    if (_isDisposed) return false;

    final trimmedEmail = email.trim();

    Logger.userAction('Request Password Reset', data: {'email': trimmedEmail});
    _safeSetState(state.copyWith(isLoading: true, clearError: true));

    try {
      await _authService.sendPasswordResetEmail(trimmedEmail);

      _safeSetState(state.copyWith(isLoading: false, clearError: true));
      Logger.success('Password reset email sent');
      return true;
    } catch (e) {
      Logger.error('Password reset request failed', error: e);
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: _formatError(e)),
      );
      return false;
    }
  }

  Future<bool> resetPassword({required String newPassword}) async {
    if (_isDisposed) return false;
    Logger.userAction('Reset Password');
    _safeSetState(state.copyWith(isLoading: true, clearError: true));

    try {
      await _authService.updatePassword(newPassword);

      _safeSetState(state.copyWith(isLoading: false, clearError: true));
      Logger.success('Password updated');
      return true;
    } catch (e) {
      Logger.error('Failed to reset password', error: e);
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: _formatError(e)),
      );
      return false;
    }
  }

  Future<void> deleteAccount() async {
    if (_isDisposed) return;
    Logger.userAction('Delete Account');
    _safeSetState(state.copyWith(isLoading: true, clearError: true));

    try {
      await _authService.deleteAccount();
      await _storage.clear();

      _safeSetState(const AuthState(status: AuthStatus.unauthenticated));
      Logger.success('Account deleted');
    } catch (e) {
      Logger.error('Failed to delete account', error: e);
      _safeSetState(
        state.copyWith(isLoading: false, errorMessage: _formatError(e)),
      );
    }
  }

  Future<void> logout() async {
    if (_isDisposed) return;

    Logger.userAction('Logout');

    try {
      await _authService.logout();
      await _storage.removeDeviceToken();

      _safeSetState(const AuthState(status: AuthStatus.unauthenticated));
      Logger.success('Logout successful');
    } catch (e) {
      Logger.error('Logout failed', error: e);
      _safeSetState(state.copyWith(errorMessage: _formatError(e)));
    }
  }

  void clearError() {
    if (!_isDisposed) {
      _safeSetState(state.copyWith(clearError: true));
    }
  }

  String _formatError(Object e) {
    final message = e.toString();
    return message.startsWith('Exception: ')
        ? message.replaceFirst('Exception: ', '')
        : message;
  }
}

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AuthState>((
  ref,
) {
  final authService = ref.watch(firebaseAuthServiceProvider);
  final storage = ref.watch(storageServiceProvider);
  return AuthViewModel(authService, storage);
});
