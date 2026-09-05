import '../model/user_model.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthState {
  final UserModel? user;
  final AuthStatus status;
  final bool isLoading;
  final String? errorMessage;

  const AuthState({
    this.user,
    this.status = AuthStatus.unknown,
    this.isLoading = false,
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated;

  bool get isEmailVerified => user?.emailVerified ?? false;

  AuthState copyWith({
    UserModel? user,
    bool clearUser = false,
    AuthStatus? status,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AuthState(
      user: clearUser ? null : (user ?? this.user),
      status: status ?? this.status,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
