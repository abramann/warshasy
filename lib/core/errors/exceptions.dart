// Exceptions
class ServerException implements Exception {
  final String message;
  ServerException([this.message = 'Server error occurred']);
}

class CacheException implements Exception {
  final String message;
  CacheException([this.message = 'Cache error occurred']);
}

class AuthenticationException implements Exception {
  final String message;
  AuthenticationException([this.message = 'Authentication failed']);
}

class ConnectionTimeoutException implements Exception {
  final String message;
  ConnectionTimeoutException([this.message = 'No internet connection']);
  @override
  String toString() => message;
}

class ValidationException implements Exception {
  final String message;
  ValidationException([this.message = 'Validation failed']);
}
