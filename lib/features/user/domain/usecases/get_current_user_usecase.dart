import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetCurrentUserUsecase implements UseCase<User?, void> {
  final UserRepository repository;

  GetCurrentUserUsecase(this.repository);

  @override
  Future<User?> call(void v) async {
    return await repository.getCurrentUser();
  }
}
