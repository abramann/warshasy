import 'package:equatable/equatable.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/user_repository.dart';

class UploadAvatarUseCase implements UseCase<String, UploadAvatarParams> {
  final UserRepository repository;

  UploadAvatarUseCase(this.repository);

  @override
  Future<String> call(UploadAvatarParams params) async {
    return await repository.uploadAvatar(
      userId: params.userId,
      filePath: params.filePath,
    );
  }
}

class UploadAvatarParams extends Equatable {
  final String userId;
  final String filePath;

  const UploadAvatarParams({required this.userId, required this.filePath});

  @override
  List<Object> get props => [userId, filePath];
}
