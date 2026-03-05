import 'package:dartz/dartz.dart';
import '../entities/user.dart';
import '../entities/auth_failure.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;
  Future<Either<AuthFailure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, User>> createUserWithEmailAndPassword({
    required String email,
    required String password,
  });

  Future<Either<AuthFailure, void>> signOut();

  Future<User?> getCurrentUser();

  Future<bool> isAuthenticated();
}
