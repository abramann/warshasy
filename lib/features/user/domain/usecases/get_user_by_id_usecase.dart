import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserByIdUseCase implements UseCase<User, GetUserByIdParams> {
  final UserRepository repository;

  GetUserByIdUseCase(this.repository);

  @override
  Future<User> call(GetUserByIdParams params) async {
    return await repository.getUserById(params.userId);
  }
}

class GetUserByIdParams extends Equatable {
  final String userId;

  const GetUserByIdParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
