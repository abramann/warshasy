import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class GetUserByPhoneUseCase implements UseCase<User?, GetUserByPhoneParams> {
  final UserRepository repository;

  GetUserByPhoneUseCase(this.repository);

  @override
  Future<User?> call(GetUserByPhoneParams params) async {
    return await repository.getUserByPhone(params.phone);
  }
}

class GetUserByPhoneParams extends Equatable {
  final String phone;

  const GetUserByPhoneParams({required this.phone});

  @override
  List<Object> get props => [phone];
}
