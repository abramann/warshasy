import 'package:warshasy/core/config/config.dart';
import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/user/data/datasources/user_remote_datasource.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserRemoteDataSource remoteDataSource;

  UserRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User?> getCurrentUser() async {
    final session = sl<AuthSession>();
    if (session.phone == null) return null;

    return await remoteDataSource.getUserByPhone(session.phone!);
  }

  @override
  Future<User> getUserById(String userId) async {
    return await remoteDataSource.getUserById(userId);
  }

  @override
  Future<User?> getUserByPhone(String phone) async {
    return await remoteDataSource.getUserByPhone(phone);
  }

  @override
  Future<User> createUser({
    required String phone,
    required String fullName,
    City? city,
    String? bio,
  }) async {
    return await remoteDataSource.createUser(
      phone: phone,
      fullName: fullName,
      city: city,
      bio: bio,
    );
  }

  @override
  Future<User> updateUser({
    required String userId,
    String? fullName,
    City? city,
    String? avatarUrl,
    String? bio,
  }) async {
    return await remoteDataSource.updateUser(
      userId: userId,
      fullName: fullName,
      city: city,
      avatarUrl: avatarUrl,
      bio: bio,
    );
  }

  @override
  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
  }) async {
    return await remoteDataSource.uploadAvatar(
      userId: userId,
      filePath: filePath,
    );
  }

  @override
  Future<void> deleteAvatar(String userId) async {
    await remoteDataSource.deleteAvatar(userId);
  }

  @override
  Future<void> deactivateUser(String userId) async {
    await remoteDataSource.deactivateUser(userId);
  }

  @override
  Future<void> reactivateUser(String userId) async {
    await remoteDataSource.reactivateUser(userId);
  }

  @override
  Future<bool> phoneExists(String phone) async {
    return await remoteDataSource.phoneExists(phone);
  }

  @override
  Future<List<User>> searchUsers({
    String? query,
    City? city,
    int? limit,
  }) async {
    return await remoteDataSource.searchUsers(
      query: query,
      city: city,
      limit: limit,
    );
  }
}
