// lib/core/config/app_routes.dart
class AppRouteName {
  static const home = 'home';

  // Auth
  static const login = 'login';
  static const verifyCode = 'verify-code';

  // Profile
  static const profile = 'profile';
  static const profileSetup = 'profile-setup';
  static const profileDetail = 'profile-detail';

  // Services / actions
  static const searchService = 'search-service';
  static const addService = 'add-service';
  static const serviceProviders = 'service-providers';
  static const categoryServices = 'category-services';
  // Chat
  static const chats = 'chats';
  static const chatDetail = 'chat-detail';
}

class AppRoutePath {
  static const root = '/';
  static const home = '/home';

  // Auth
  static const login = '/login';
  static const verifyCode = 'verify-code';

  // Profile
  static const profile = '/profile';
  static const profileSetup = 'profile-setup';
  // Services
  static const searchService = '/search-service';
  static const addService = '/add-service';
  static const serviceProviders = '/service-providers';
  static const categories = '/categories';

  // Chat
  static const chats = '/chats';
}
