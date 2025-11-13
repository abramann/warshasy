import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class CheckPhoneExistsUseCase implements UseCase<bool, CheckPhoneExistsParams> {
  final UserRepository repository;

  CheckPhoneExistsUseCase(this.repository);

  @override
  Future<bool> call(CheckPhoneExistsParams params) async {
    return await repository.phoneExists(params.phone);
  }
}

class CheckPhoneExistsParams extends Equatable {
  final String phone;

  const CheckPhoneExistsParams({required this.phone});

  @override
  List<Object> get props => [phone];
}
