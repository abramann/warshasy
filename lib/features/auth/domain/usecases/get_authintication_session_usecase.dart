import 'package:dartz/dartz.dart';
import 'package:warshasy/core/usecases/usecase.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/auth/domain/repositories/auth_repository.dart';

class GetAuthinticationSessionUseCase
    implements UseCase<AuthSession?, NoParams> {
  final AuthRepository repository;

  GetAuthinticationSessionUseCase(this.repository);

  @override
  Future<AuthSession?> call(NoParams params) async {
    return await repository.getAuthenticationSession();
  }
}
