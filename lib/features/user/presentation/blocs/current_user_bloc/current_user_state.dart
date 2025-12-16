// lib/features/user/domain/presentation/blocs/current_user_state.dart
part of 'current_user_bloc.dart';

abstract class CurrentUserState extends Equatable {
  const CurrentUserState();

  @override
  List<Object?> get props => [];
}

class CurrentUserInitial extends CurrentUserState {
  const CurrentUserInitial();
}

class CurrentUserLoading extends CurrentUserState {
  const CurrentUserLoading();
}

class CurrentUserLoaded extends CurrentUserState {
  final User user;
  const CurrentUserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class CurrentUserUpdating extends CurrentUserLoaded {
  const CurrentUserUpdating({required super.user});
}

class CurrentUserUpdated extends CurrentUserLoaded {
  const CurrentUserUpdated({required super.user});
}

class CurrentUserAvatarUploaded extends CurrentUserLoaded {
  final String avatarUrl;

  const CurrentUserAvatarUploaded({
    required this.avatarUrl,
    required super.user,
  });

  @override
  List<Object> get props => [avatarUrl, super.user];
}

class CurrentUserAvatarDeleted extends CurrentUserLoaded {
  const CurrentUserAvatarDeleted({required super.user});
}

class CurrentUserError extends CurrentUserState {
  final Failure failure;

  const CurrentUserError({required this.failure});

  @override
  List<Object> get props => [failure];
}

class CurrentUserClear extends CurrentUserState {
  const CurrentUserClear();
}
