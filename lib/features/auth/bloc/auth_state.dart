part of 'auth_bloc.dart';

enum AuthStatus { unknown, unauthenticated, authenticated, loading, failure }

class AuthState extends Equatable {
  final AuthStatus status;
  final String? userId;
  final String? email;
  final String? errorMessage;

  const AuthState._({
    required this.status,
    this.userId,
    this.email,
    this.errorMessage,
  });

  const AuthState.unknown() : this._(status: AuthStatus.unknown);

  const AuthState.unauthenticated()
    : this._(status: AuthStatus.unauthenticated);

  const AuthState.authenticated({required String userId, required String email})
    : this._(status: AuthStatus.authenticated, userId: userId, email: email);

  const AuthState.loading() : this._(status: AuthStatus.loading);

  const AuthState.failure(String message)
    : this._(status: AuthStatus.failure, errorMessage: message);

  bool get isLoading => status == AuthStatus.loading;
  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isUnauthenticated => status == AuthStatus.unauthenticated;

  @override
  List<Object?> get props => [status, userId, email, errorMessage];
}
