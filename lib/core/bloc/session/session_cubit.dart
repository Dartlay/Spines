import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:shared_preferences/shared_preferences.dart';
import 'session_state.dart';

class SessionCubit extends Cubit<SessionState> {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  SessionCubit({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
      super(SessionState.initial()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    emit(state.copyWith(isLoading: true));

    try {
      final user = _firebaseAuth.currentUser;
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString('user_language');

      if (user != null) {
        emit(
          state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            userId: user.uid,
            email: user.email,
            selectedLanguage: savedLanguage,
          ),
        );
      } else {
        emit(
          state.copyWith(
            isLoading: false,
            isAuthenticated: false,
            selectedLanguage: savedLanguage,
          ),
        );
      }
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Failed to check auth status: $e',
        ),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        final savedLanguage = prefs.getString('user_language');
        emit(
          state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            userId: user.uid,
            email: user.email,
            selectedLanguage: savedLanguage,
            error: null,
          ),
        );

        debugPrint('✅ Login successful for: $email');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase auth error: ${e.code}');

      String errorMessage = _mapFirebaseError(e);

      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          error: errorMessage,
        ),
      );
    } catch (e) {
      debugPrint('❌ Login error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          error: 'Ошибка входа',
        ),
      );
    }
  }

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        final savedLanguage = prefs.getString('user_language');

        emit(
          state.copyWith(
            isLoading: false,
            isAuthenticated: true,
            userId: user.uid,
            email: user.email,
            selectedLanguage: savedLanguage,
            error: null,
          ),
        );

        debugPrint('✅ Registration successful for: $email');
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      debugPrint('❌ Firebase auth error: ${e.code}');

      String errorMessage = _mapFirebaseError(e);
      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          error: errorMessage,
        ),
      );
    } catch (e) {
      debugPrint('❌ Registration error: $e');
      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          error: 'Ошибка регистрации',
        ),
      );
    }
  }

  Future<void> logout() async {
    emit(state.copyWith(isLoading: true));

    try {
      await _firebaseAuth.signOut();
      emit(
        state.copyWith(
          isLoading: false,
          isAuthenticated: false,
          userId: null,
          email: null,
          error: null,
        ),
      );

      debugPrint('✅ Logout successful');
    } catch (e) {
      debugPrint('❌ Logout failed: $e');
      emit(state.copyWith(isLoading: false, error: 'Ошибка выхода'));
    }
  }

  Future<void> onLanguageSelected(String languageCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_language', languageCode);

      emit(
        state.copyWith(
          selectedLanguage: languageCode,
          isAuthenticated: false,
          isLoading: false,
          error: null,
        ),
      );

      debugPrint('✅ Language saved: $languageCode');
      debugPrint('🔍 After language select: needsAuth=${state.needsAuth}');
    } catch (e) {
      debugPrint('❌ Error saving language: $e');
      emit(state.copyWith(error: 'Failed to save language: $e'));
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
      case 'invalid-credential':
        return 'Неверный email или пароль';
      case 'email-already-in-use':
        return 'Этот email уже используется';
      case 'weak-password':
        return 'Слишком слабый пароль';
      case 'network-request-failed':
        return 'Ошибка сети. Проверьте подключение';
      default:
        return 'Ошибка входа: ${e.message ?? 'неизвестная ошибка'}';
    }
  }
}
