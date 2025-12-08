// lib/features/user/domain/presentation/blocs/current_user_event.dart
part of 'current_user_bloc.dart';

abstract class CurrentUserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadCurrentUser extends CurrentUserEvent {
  final String userId;
  final bool forceRefresh;

  LoadCurrentUser({required this.userId, this.forceRefresh = false});

  @override
  List<Object?> get props => [userId, forceRefresh];
}

class RefreshCurrentUser extends CurrentUserEvent {
  final String userId;

  RefreshCurrentUser({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateCurrentUser extends CurrentUserEvent {
  final User user;

  UpdateCurrentUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class UploadCurrentUserAvatar extends CurrentUserEvent {
  final String filePath;

  UploadCurrentUserAvatar({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

class DeleteCurrentUserAvatar extends CurrentUserEvent {
  final String userId;

  DeleteCurrentUserAvatar({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class ClearCurrentUser extends CurrentUserEvent {}
