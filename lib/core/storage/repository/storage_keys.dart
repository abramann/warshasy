// lib/core/constants/storage_keys.dart

/// Constants for SharedPreferences keys
/// Centralized to avoid typos and make refactoring easier
class StorageKeys {
  // Private constructor to prevent instantiation
  StorageKeys._();

  // ============================================
  // USER INFORMATION
  // ============================================
  static const String userId = 'user_id';
  static const String userPhone = 'user_phone';
  static const String userFullName = 'user_full_name';
  static const String userCity = 'user_city';
  static const String userType = 'user_type';
  static const String userAvatarUrl = 'user_avatar_url';
  static const String isAuthenticated = 'is_authenticated';
  static const String authToken = 'auth_token';
  static const String lastLoginTimestamp = 'last_login_timestamp';

  static const String profileCompleted = 'profile_completed';
  static const String needsProfileSetup = 'needs_profile_setup';

  // Complete user object (JSON)
  static const String userObject = 'user_object';

  // ============================================
  // APP SETTINGS
  // ============================================
  static const String isFirstLaunch = 'is_first_launch';
  static const String appLanguage = 'app_language';
  static const String isDarkMode = 'is_dark_mode';
  static const String notificationsEnabled = 'notifications_enabled';

  // ============================================
  // SEARCH & FILTERS
  // ============================================
  static const String lastSearchCity = 'last_search_city';
  static const String lastSearchProfession = 'last_search_profession';
  static const String searchHistory = 'search_history';
  static const String recentSearches = 'recent_searches';

  // ============================================
  // FAVORITES
  // ============================================
  static const String favoriteProfessionals = 'favorite_professionals';

  // ============================================
  // CACHE
  // ============================================
  static const String cachedProfessions = 'cached_professions';
  static const String cacheTimestamp = 'cache_timestamp';
  static const String cachedCities = 'cached_cities';

  // ============================================
  // PROFESSIONAL SPECIFIC
  // ============================================
  static const String professionalProfile = 'professional_profile';
  static const String professionalProfessions = 'professional_professions';
  static const String professionalDescription = 'professional_description';

  // ============================================
  // CHAT
  // ============================================
  static const String unreadMessagesCount = 'unread_messages_count';
  static const String lastChatSync = 'last_chat_sync';

  // ============================================
  // ONBOARDING
  // ============================================
  static const String hasSeenOnboarding = 'has_seen_onboarding';
  static const String onboardingCompleted = 'onboarding_completed';
}
