import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final firebase_auth.FirebaseAuth _firebaseAuth;
  late final StreamSubscription<firebase_auth.User?> _authSubscription;

  AuthBloc({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
      super(const AuthState.unknown()) {
    on<AuthStatusChecked>(_onStatusChecked);
    on<AuthSignInRequested>(_onSignInRequested);
    on<AuthSignUpRequested>(_onSignUpRequested);
    on<AuthSignOutRequested>(_onSignOutRequested);

    _authSubscription = _firebaseAuth.authStateChanges().listen((user) {
      add(const AuthStatusChecked());
    });

    add(const AuthStatusChecked());
  }

  Future<void> _onStatusChecked(
    AuthStatusChecked event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final user = _firebaseAuth.currentUser;

      if (user != null) {
        emit(
          AuthState.authenticated(userId: user.uid, email: user.email ?? ''),
        );
      } else {
        emit(const AuthState.unauthenticated());
      }
    } catch (e) {
      emit(const AuthState.unauthenticated());
    }
  }

  Future<void> _onSignInRequested(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final user = userCredential.user;
      if (user != null) {
        emit(
          AuthState.authenticated(userId: user.uid, email: user.email ?? ''),
        );
      } else {
        emit(const AuthState.failure('Ошибка входа'));
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthState.failure(_mapFirebaseError(e)));
    } catch (e) {
      emit(AuthState.failure('Произошла неизвестная ошибка'));
    }
  }

  Future<void> _onSignUpRequested(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: event.email,
        password: event.password,
      );

      final user = userCredential.user;
      if (user != null) {
        emit(
          AuthState.authenticated(userId: user.uid, email: user.email ?? ''),
        );
      } else {
        emit(const AuthState.failure('Ошибка регистрации'));
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      emit(AuthState.failure(_mapFirebaseError(e)));
    } catch (e) {
      emit(AuthState.failure('Произошла неизвестная ошибка'));
    }
  }

  Future<void> _onSignOutRequested(
    AuthSignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthState.loading());

    try {
      await _firebaseAuth.signOut();
      emit(const AuthState.unauthenticated());
    } catch (e) {
      emit(AuthState.failure('Ошибка выхода из системы'));
    }
  }

  String _mapFirebaseError(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Неверный формат email';
      case 'user-disabled':
        return 'Пользователь заблокирован';
      case 'user-not-found':
        return 'Пользователь не найден';
      case 'wrong-password':
        return 'Неверный пароль';
      case 'email-already-in-use':
        return 'Этот email уже используется';
      case 'weak-password':
        return 'Слишком слабый пароль';
      case 'network-request-failed':
        return 'Ошибка сети. Проверьте подключение';
      case 'invalid-credential':
        return 'Неверный email или пароль';
      default:
        return e.message ?? 'Ошибка аутентификации';
    }
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
