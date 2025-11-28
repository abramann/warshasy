import 'package:warshasy/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:warshasy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDatasource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  // تسجيل الدخول عبر رقم الهاتف + كود التفعيل
  @override
  Future<AuthSession> signInWithPhone({
    required String phone,
    required String code,
  }) async {
    final session = await remoteDataSource.signInWithPhone(phone, code);

    await localDataSource.saveAuthSession(session);

    return session;
  }

  // إرسال كود التفعيل عبر واتساب (OTP)
  @override
  Future<void> sendVerificationCode({required String phone}) async {
    return await remoteDataSource.sendVerificationCode(phone: phone);
  }

  // تسجيل الخروج (محلي فقط)
  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
    await localDataSource.clearAuthSession();
  }

  @override
  Future<void> persistSession(AuthSession session) async {
    await localDataSource.saveAuthSession(session);
  }

  @override
  Future<AuthSession?> getStoredSession() async {
    return await localDataSource.getAuthSession();
  }
}
