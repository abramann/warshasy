import 'package:dartz/dartz.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/core/usecases/usecase.dart';
import 'package:warshasy/features/auth/domain/repositories/auth_repository.dart';

class SendVerificationCodeUsecase extends UseCase<void, String> {
  final AuthRepository repository;
  SendVerificationCodeUsecase(this.repository);

  @override
  Future<void> call(String phone) async =>
      await repository.sendVerificationCode(phone: phone);
}
