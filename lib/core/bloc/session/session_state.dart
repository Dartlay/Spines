import 'package:equatable/equatable.dart';

class SessionState extends Equatable {
  final bool isLoading;
  final String? selectedLanguage;
  final bool isAuthenticated;
  final String? userId;
  final String? email;
  final String? token;
  final String? error;

  const SessionState({
    required this.isLoading,
    this.selectedLanguage,
    required this.isAuthenticated,
    this.userId,
    this.email,
    this.token,
    this.error,
  });

  factory SessionState.initial() {
    return const SessionState(
      isLoading: false,
      selectedLanguage: null,
      isAuthenticated: false,
      userId: null,
      email: null,
      token: null,
      error: null,
    );
  }

  bool get needsLanguage => selectedLanguage == null && !isLoading;
  bool get needsAuth =>
      !isAuthenticated && !isLoading && selectedLanguage != null;

  SessionState copyWith({
    bool? isLoading,
    String? selectedLanguage,
    bool? isAuthenticated,
    String? userId,
    String? email,
    String? token,
    String? error,
  }) {
    return SessionState(
      isLoading: isLoading ?? this.isLoading,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      userId: userId ?? this.userId,
      email: email ?? this.email,
      token: token ?? this.token,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    isLoading,
    selectedLanguage,
    isAuthenticated,
    userId,
    email,
    token,
    error,
  ];
}
