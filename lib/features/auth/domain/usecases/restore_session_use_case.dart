import 'package:warshasy/core/usecases/usecase.dart';
import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';

class RestoreSessionUseCase extends UseCase<void, AuthSession> {
  final AuthRepository repository;

  RestoreSessionUseCase(this.repository);

  @override
  Future<void> call(AuthSession session) async {
    await repository.persistSession(session);
  }
}
