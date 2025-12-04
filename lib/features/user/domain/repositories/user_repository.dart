// ============================================
// lib/features/user/domain/repositories/user_repository.dart
// ============================================
import 'package:warshasy/features/user/domain/entities/city.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';

abstract class UserRepository {
  /// Get user by ID
  Future<User> getUserById(String userId);

  Future<User?> getCurrentUser();

  /// Get user by phone number
  Future<User?> getUserByPhone(String phone);

  /// Create a new user
  Future<User> createUser({
    required String phone,
    required String fullName,
    City? city,
    String? bio,
  });

  /// Update user profile
  Future<User> updateUser({required User user});

  /// Upload user avatar
  Future<String> uploadAvatar({
    required String userId,
    required String filePath,
  });

  /// Delete user avatar
  Future<void> deleteAvatar(String userId);

  /// Deactivate user account
  Future<void> deactivateUser(String userId);

  /// Reactivate user account
  Future<void> reactivateUser(String userId);

  /// Check if phone number exists
  Future<bool> phoneExists(String phone);

  /// Search users by name or phone
  Future<List<User>> searchUsers({String? query, City? city, int? limit});
}
