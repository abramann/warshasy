import 'package:warshasy/core/storage/storage_service.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';

abstract class AuthLocalDatasource {
  Future<AuthSession?> getAuthSession();
  Future<void> saveAuthSession(AuthSession profile);
  Future<void> clearAuthSession();
}

class AuthLocalDatasourceImpl implements AuthLocalDatasource {
  final String authSessionKey = 'auth_session';
  final StorageService storageService;

  AuthLocalDatasourceImpl({required this.storageService});

  @override
  Future<AuthSession?> getAuthSession() async {
    final sessionJson = storageService.getJson(authSessionKey);
    if (sessionJson == null) {
      return null;
    }
    return AuthSession.fromJson(sessionJson);
  }

  @override
  Future<void> saveAuthSession(AuthSession session) async {
    await storageService.saveJson(authSessionKey, session.toJson());
  }

  @override
  Future<void> clearAuthSession() async {
    await storageService.remove(authSessionKey);
  }
}
