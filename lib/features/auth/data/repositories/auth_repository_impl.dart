import 'package:warshasy/core/utils/device_info.dart';
import 'package:warshasy/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:warshasy/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDatasource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<AuthSession> signIn({
    required String otpSessionId,
    required String code,
  }) async {
    final deviceId = await DeviceInfo.getID();

    final session = await remote.verifyCodeAndCreateSession(
      code: code,
      otpSessionId: otpSessionId,
      deviceId: deviceId,
    );

    await local.saveSession(session);
    return session;
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final stored = await local.getSession();
    final deviceId = await DeviceInfo.getID();

    if (stored == null) {
      return null;
    }

    // If deviceId changed (edge case), force re-login
    if (stored.deviceId != deviceId) {
      await local.clearSession();
      return null;
    }

    final remoteSession = await remote.restoreSession(
      deviceId: stored.deviceId,
      sessionToken: stored.sessionToken,
    );

    if (remoteSession == null) {
      await local.clearSession();
      return null;
    }

    await local.saveSession(remoteSession);
    return remoteSession;
  }

  @override
  Future<String> sendVerificationCode({required String phone}) async {
    return await remote.sendVerificationCode(phone: phone);
  }

  @override
  Future<void> signOut() async {
    final stored = await local.getSession();
    if (stored != null) {
      await remote.invalidateSession(
        deviceId: stored.deviceId,
        sessionToken: stored.sessionToken,
      );
    }
    await local.clearSession();
  }

  @override
  Future<AuthSession?> getStoredSession() async {
    return await local.getSession();
  }
}
