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
  static const requestService = 'request-service';
  static const postService = 'post-service';
  static const serviceDetail = 'service-detail';

  // Chat
  static const chats = 'chats';
  static const chatDetail = 'chat-detail';
}

class AppRoutePath {
  static const root = '/';
  static const home = '/home';

  // Auth
  static const login = '/login';

  // Profile
  static const profile = '/profile';

  // Services
  static const requestService = '/request-service';
  static const postService = '/post-service';
  static const serviceDetail = '/service';

  // Chat
  static const chats = '/chats';
}
