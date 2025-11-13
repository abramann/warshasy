import 'package:warshasy/core/storage/repository/storage_keys.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';

import '../../../features/user/domain/entities/user.dart';
import '../../../features/user/data/models/user_model.dart';
import '../storage_service.dart';

/// High-level repository for common storage operations
/// Provides business-logic-specific methods on top of StorageService
class LocalStorageRepository {
  final StorageService _storageService;

  LocalStorageRepository(this._storageService);

  // ============================================
  // USER OPERATIONS
  // ============================================

  /// Save user to local storage
  Future<bool> saveUser(User user) async {
    try {
      final userModel = UserModel.fromEntity(user);
      await _storageService.saveString(StorageKeys.userPhone, user.phone);
      await _storageService.saveString(
        StorageKeys.userFullName,
        user.fullName ?? '',
      );
      if (user.city != null) {
        await _storageService.saveString(
          StorageKeys.userCity,
          user.city!.arabicName,
        );
      }
      if (user.avatarUrl != null) {
        await _storageService.saveString(
          StorageKeys.userAvatarUrl,
          user.avatarUrl!,
        );
      }

      // Save complete user object as JSON
      final success = await _storageService.saveJson(
        StorageKeys.userObject,
        userModel.toJson(),
      );

      if (success) {
        await _storageService.saveBool(StorageKeys.isAuthenticated, true);
      }

      return success;
    } catch (e) {
      return false;
    }
  }

  /// Get user from local storage
  User? getUser() {
    try {
      final userJson = _storageService.getJson(StorageKeys.userObject);
      if (userJson == null) return null;
      return UserModel.fromJson(userJson);
    } catch (e) {
      return null;
    }
  }

  /// Get user ID
  String? getUserId() {
    return _storageService.getString(StorageKeys.userId);
  }

  /// Get user phone
  String? getUserPhone() {
    return _storageService.getString(StorageKeys.userPhone);
  }

  /// Check if user is authenticated
  bool isAuthenticated() {
    return _storageService.getBool(StorageKeys.isAuthenticated) ?? false;
  }

  /// Clear user data (logout)
  Future<bool> clearUserData() async {
    try {
      await _storageService.removeMultiple([
        StorageKeys.userId,
        StorageKeys.userPhone,
        StorageKeys.userFullName,
        StorageKeys.userCity,
        StorageKeys.userType,
        StorageKeys.userAvatarUrl,
        StorageKeys.userObject,
        StorageKeys.isAuthenticated,
        StorageKeys.authToken,
      ]);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================
  // APP SETTINGS
  // ============================================

  /// Check if this is the first launch
  bool isFirstLaunch() {
    return _storageService.getBoolOrDefault(StorageKeys.isFirstLaunch, true);
  }

  /// Mark first launch as complete
  Future<bool> setFirstLaunchComplete() async {
    return await _storageService.saveBool(StorageKeys.isFirstLaunch, false);
  }

  /// Check if onboarding is completed
  bool hasCompletedOnboarding() {
    return _storageService.getBoolOrDefault(
      StorageKeys.onboardingCompleted,
      false,
    );
  }

  /// Mark onboarding as completed
  Future<bool> setOnboardingCompleted() async {
    return await _storageService.saveBool(
      StorageKeys.onboardingCompleted,
      true,
    );
  }

  /// Get dark mode preference
  bool isDarkMode() {
    return _storageService.getBoolOrDefault(StorageKeys.isDarkMode, false);
  }

  /// Set dark mode preference
  Future<bool> setDarkMode(bool value) async {
    return await _storageService.saveBool(StorageKeys.isDarkMode, value);
  }

  /// Get notifications enabled preference
  bool areNotificationsEnabled() {
    return _storageService.getBoolOrDefault(
      StorageKeys.notificationsEnabled,
      true,
    );
  }

  /// Set notifications preference
  Future<bool> setNotificationsEnabled(bool value) async {
    return await _storageService.saveBool(
      StorageKeys.notificationsEnabled,
      value,
    );
  }

  // ============================================
  // SEARCH HISTORY
  // ============================================

  /// Save last search city
  Future<bool> saveLastSearchCity(String city) async {
    return await _storageService.saveString(StorageKeys.lastSearchCity, city);
  }

  /// Get last search city
  String? getLastSearchCity() {
    return _storageService.getString(StorageKeys.lastSearchCity);
  }

  /// Save recent searches (list of profession names)
  Future<bool> addRecentSearch(String professionName) async {
    try {
      final recentSearches = getRecentSearches();

      // Remove if already exists
      recentSearches.remove(professionName);

      // Add to beginning
      recentSearches.insert(0, professionName);

      // Keep only last 10
      if (recentSearches.length > 10) {
        recentSearches.removeRange(10, recentSearches.length);
      }

      return await _storageService.saveStringList(
        StorageKeys.recentSearches,
        recentSearches,
      );
    } catch (e) {
      return false;
    }
  }

  /// Get recent searches
  List<String> getRecentSearches() {
    return _storageService.getStringListOrDefault(
      StorageKeys.recentSearches,
      [],
    );
  }

  /// Clear recent searches
  Future<bool> clearRecentSearches() async {
    return await _storageService.remove(StorageKeys.recentSearches);
  }

  // ============================================
  // FAVORITES
  // ============================================

  /// Add professional to favorites
  Future<bool> addFavorite(String professionalId) async {
    try {
      final favorites = getFavorites();
      if (!favorites.contains(professionalId)) {
        favorites.add(professionalId);
        return await _storageService.saveStringList(
          StorageKeys.favoriteProfessionals,
          favorites,
        );
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove professional from favorites
  Future<bool> removeFavorite(String professionalId) async {
    try {
      final favorites = getFavorites();
      favorites.remove(professionalId);
      return await _storageService.saveStringList(
        StorageKeys.favoriteProfessionals,
        favorites,
      );
    } catch (e) {
      return false;
    }
  }

  /// Get all favorite professional IDs
  List<String> getFavorites() {
    return _storageService.getStringListOrDefault(
      StorageKeys.favoriteProfessionals,
      [],
    );
  }

  /// Check if professional is favorite
  bool isFavorite(String professionalId) {
    return getFavorites().contains(professionalId);
  }

  // ============================================
  // CACHE OPERATIONS
  // ============================================

  /// Save cache timestamp
  Future<bool> saveCacheTimestamp() async {
    return await _storageService.saveString(
      StorageKeys.cacheTimestamp,
      DateTime.now().toIso8601String(),
    );
  }

  /// Check if cache is valid (less than 1 hour old)
  bool isCacheValid({Duration maxAge = const Duration(hours: 1)}) {
    final timestampStr = _storageService.getString(StorageKeys.cacheTimestamp);
    if (timestampStr == null) return false;

    try {
      final timestamp = DateTime.parse(timestampStr);
      final age = DateTime.now().difference(timestamp);
      return age < maxAge;
    } catch (e) {
      return false;
    }
  }

  // ============================================
  // CHAT OPERATIONS
  // ============================================

  /// Save unread messages count
  Future<bool> saveUnreadCount(int count) async {
    return await _storageService.saveInt(
      StorageKeys.unreadMessagesCount,
      count,
    );
  }

  /// Get unread messages count
  int getUnreadCount() {
    return _storageService.getIntOrDefault(StorageKeys.unreadMessagesCount, 0);
  }

  // ============================================
  // UTILITY
  // ============================================

  /// Clear all app data (for testing/development)
  Future<bool> clearAllData() async {
    return await _storageService.clearAll();
  }
}
