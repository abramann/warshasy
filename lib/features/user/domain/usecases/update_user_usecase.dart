import 'package:equatable/equatable.dart';
import 'package:warshasy/features/auth/auth.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

class UpdateUserUseCase implements UseCase<User, UpdateUserParams> {
  final UserRepository repository;

  UpdateUserUseCase(this.repository);

  @override
  Future<User> call(UpdateUserParams params) async {
    return await repository.updateUser(
      userId: params.userId,
      fullName: params.fullName,
      city: params.city,
      avatarUrl: params.avatarUrl,
      bio: params.bio,
    );
  }
}

class UpdateUserParams extends Equatable {
  final String userId;
  final String? fullName;
  final City? city;
  final String? avatarUrl;
  final String? bio;

  const UpdateUserParams({
    required this.userId,
    this.fullName,
    this.city,
    this.avatarUrl,
    this.bio,
  });

  @override
  List<Object?> get props => [userId, fullName, city, avatarUrl, bio];
}
