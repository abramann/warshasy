import 'package:dartz/dartz.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import '../../../../core/errors/failures.dart';
import '../../../user/domain/entities/user.dart';

abstract class AuthRepository {
  Future<AuthSession> signIn({
    required String otpSessionId,
    required String code,
  });

  Future<String> sendVerificationCode({required String phone});

  Future<void> signOut();

  Future<AuthSession?> getStoredSession();

  Future<AuthSession?> restoreSession();

  /// Map AuthException to specific Failure types
  // Failure _mapAuthException(AuthException exception);
}
