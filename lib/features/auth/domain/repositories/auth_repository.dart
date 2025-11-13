import 'package:dartz/dartz.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import '../../../../core/errors/failures.dart';
import '../../../user/domain/entities/user.dart';

abstract class AuthRepository {
  Future<AuthSession> signInWithPhone({
    required String phone,
    required String code,
  });

  Future<void> sendVerificationCode({required String phone});

  Future<void> signOut();

  Future<AuthSession?> getAuthenticationSession();

  Future<bool> isAuthenticated();

  /// Map AuthException to specific Failure types
  // Failure _mapAuthException(AuthException exception);
}
