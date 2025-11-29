part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  const UserState();

  @override
  List<Object?> get props => [];
}

// Initial state
class UserInitial extends UserState {
  const UserInitial();
}

// Loading state
class UserLoading extends UserState {
  const UserLoading();
}

// User loaded successfully
class UserLoaded extends UserState {
  final User user;

  const UserLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

// Multiple users loaded (for search)
class UsersLoaded extends UserState {
  final List<User> users;

  const UsersLoaded({required this.users});

  @override
  List<Object> get props => [users];
}

// User updated successfully
class UserUpdated extends UserState {
  final User user;

  const UserUpdated({required this.user});

  @override
  List<Object> get props => [user];
}

// Avatar uploaded successfully
class AvatarUploaded extends UserState {
  final String avatarUrl;

  const AvatarUploaded({required this.avatarUrl});

  @override
  List<Object> get props => [avatarUrl];
}

// Avatar deleted successfully
class AvatarDeleted extends UserState {
  const AvatarDeleted();
}

// Phone exists check result
class PhoneExistsChecked extends UserState {
  final bool exists;

  const PhoneExistsChecked({required this.exists});

  @override
  List<Object> get props => [exists];
}

// Error state - Changed to use Failure instead of String message
class UserError extends UserState {
  final Failure failure;

  const UserError({required this.failure});

  @override
  List<Object> get props => [failure];
}
