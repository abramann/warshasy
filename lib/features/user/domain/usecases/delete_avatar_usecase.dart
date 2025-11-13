import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class DeleteAvatarUseCase implements UseCase<void, DeleteAvatarParams> {
  final UserRepository repository;

  DeleteAvatarUseCase(this.repository);

  @override
  Future<void> call(DeleteAvatarParams params) async {
    return await repository.deleteAvatar(params.userId);
  }
}

class DeleteAvatarParams extends Equatable {
  final String userId;

  const DeleteAvatarParams({required this.userId});

  @override
  List<Object> get props => [userId];
}
