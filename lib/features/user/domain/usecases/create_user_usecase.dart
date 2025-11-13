import 'package:equatable/equatable.dart';
import 'package:warshasy/features/auth/auth.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class CreateUserUseCase implements UseCase<User, CreateUserParams> {
  final UserRepository repository;

  CreateUserUseCase(this.repository);

  @override
  Future<User> call(CreateUserParams params) async {
    return await repository.createUser(
      phone: params.phone,
      fullName: params.fullName,
      city: params.city,
      bio: params.bio,
    );
  }
}

class CreateUserParams extends Equatable {
  final String phone;
  final String fullName;
  final City? city;
  final String? bio;

  const CreateUserParams({
    required this.phone,
    required this.fullName,
    this.city,
    this.bio,
  });

  @override
  List<Object?> get props => [phone, fullName, city, bio];
}
