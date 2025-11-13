class Failure {
  final String message;

  const Failure(this.message);

  @override
  String toString() {
    return super.toString();
  }
}

class FailureUnknown extends Failure {
  FailureUnknown(super.message);

  @override
  String toString() {
    return 'Unknown error: ${super.toString()}';
  }
}

// Authentication failures
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
