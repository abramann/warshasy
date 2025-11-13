// core/errors/error_mapper.dart
import 'exceptions.dart';
import 'failures.dart';

class ErrorMapper {
  static Failure map(Exception e) {
    if (e is ServerException) return ServerFailure(e.message);
    if (e is AuthenticationException) return AuthFailure(e.message);
    if (e is CacheException) return CacheFailure(e.message);
    if (e is ConnectionTimeoutException) return Failure('Connection timed out');
    if (e is ValidationException) return Failure(e.message);
    return FailureUnknown(e.toString());
  }
}
