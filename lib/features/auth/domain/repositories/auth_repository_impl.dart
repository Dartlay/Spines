import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/auth_failure.dart';

class AuthRepositoryImpl implements AuthRepository {
  final firebase_auth.FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({firebase_auth.FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance;

  @override
  Stream<User?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser != null ? _mapFirebaseUser(firebaseUser) : null;
    });
  }

  @override
  Future<Either<AuthFailure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return Right(_mapFirebaseUser(userCredential.user!));
      } else {
        return Left(
          AuthFailure(code: 'unknown', message: 'Произошла неизвестная ошибка'),
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } catch (e) {
      return Left(
        AuthFailure(code: 'unknown', message: 'Произошла неизвестная ошибка'),
      );
    }
  }

  @override
  Future<Either<AuthFailure, User>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        return Right(_mapFirebaseUser(userCredential.user!));
      } else {
        return Left(
          AuthFailure(code: 'unknown', message: 'Произошла неизвестная ошибка'),
        );
      }
    } on firebase_auth.FirebaseAuthException catch (e) {
      return Left(_mapFirebaseAuthException(e));
    } catch (e) {
      return Left(
        AuthFailure(code: 'unknown', message: 'Произошла неизвестная ошибка'),
      );
    }
  }

  @override
  Future<Either<AuthFailure, void>> signOut() async {
    try {
      await _firebaseAuth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(
        AuthFailure(
          code: 'sign_out_failed',
          message: 'Не удалось выйти из системы',
        ),
      );
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    return user != null ? _mapFirebaseUser(user) : null;
  }

  @override
  Future<bool> isAuthenticated() async {
    return _firebaseAuth.currentUser != null;
  }

  User _mapFirebaseUser(firebase_auth.User user) {
    return User(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      isEmailVerified: user.emailVerified,
    );
  }

  AuthFailure _mapFirebaseAuthException(firebase_auth.FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AuthFailure(code: e.code, message: 'Неверный формат email');
      case 'user-disabled':
        return AuthFailure(code: e.code, message: 'Пользователь заблокирован');
      case 'user-not-found':
        return AuthFailure(code: e.code, message: 'Пользователь не найден');
      case 'wrong-password':
        return AuthFailure(code: e.code, message: 'Неверный пароль');
      case 'email-already-in-use':
        return AuthFailure(
          code: e.code,
          message: 'Этот email уже используется',
        );
      case 'weak-password':
        return AuthFailure(code: e.code, message: 'Слишком слабый пароль');
      case 'network-request-failed':
        return AuthFailure(
          code: e.code,
          message: 'Ошибка сети. Проверьте подключение',
        );
      default:
        return AuthFailure(
          code: e.code,
          message: e.message ?? 'Произошла ошибка аутентификации',
        );
    }
  }
}
