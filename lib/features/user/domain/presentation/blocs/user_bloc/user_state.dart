part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

// New state: Updating (shows user is being updated but keeps UI responsive)
class UserUpdating extends UserState {
  final User user; // Keep current user visible during update

  const UserUpdating({required this.user});

  @override
  List<Object> get props => [user];
}

class UserLoaded extends UserState {
  final User user;

  const UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class UsersLoaded extends UserState {
  final List<User> users;

  const UsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

class UserUpdated extends UserState {
  final User user;

  const UserUpdated({required this.user});

  @override
  List<Object> get props => [user];
}

class AvatarUploaded extends UserState {
  final String avatarUrl;
  final User user;

  const AvatarUploaded({required this.avatarUrl, required this.user});

  @override
  List<Object> get props => [avatarUrl, user];
}

class UserError extends UserState {
  final Failure failure;

  const UserError({required this.failure});

  @override
  List<Object> get props => [failure];
}
