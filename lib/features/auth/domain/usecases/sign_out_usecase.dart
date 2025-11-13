import 'package:dartz/dartz.dart';
import 'package:warshasy/core/usecases/usecase.dart';
import 'package:warshasy/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../../core/errors/errors.dart';

// lib/features/auth/domain/usecases/sign_out_usecase.dart

class SignOutUseCase implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  @override
  Future<void> call(NoParams params) {
    return repository.signOut();
  }
}
