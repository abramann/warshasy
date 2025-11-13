import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:warshasy/core/usecases/usecase.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/auth/domain/repositories/auth_repository.dart';
import '../../../../../../core/errors/errors.dart';

class SignInUseCase implements UseCase<AuthSession, SignInParams> {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  @override
  Future<AuthSession> call(SignInParams params) async {
    return await repository.signInWithPhone(
      phone: params.phone,
      code: params.code,
    );
  }
}

// Parameters for SignIn
class SignInParams extends Equatable {
  final String phone;
  final String code;

  const SignInParams({required this.phone, required this.code});

  @override
  List<Object> get props => [phone, code];
}
