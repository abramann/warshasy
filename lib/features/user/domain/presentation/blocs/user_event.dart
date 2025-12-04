part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Load user by ID (with optional force refresh)
class LoadUserRequested extends UserEvent {
  final String userId;
  final bool forceRefresh;

  LoadUserRequested({required this.userId, this.forceRefresh = false});

  @override
  List<Object?> get props => [userId, forceRefresh];
}

// Refresh user silently (without loading state)
class RefreshUserRequested extends UserEvent {
  final String userId;

  RefreshUserRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileRequested extends UserEvent {
  final User user;

  UpdateProfileRequested({required this.user});

  @override
  List<Object?> get props => [user];
}

class UploadAvatarRequested extends UserEvent {
  final String userId;
  final String filePath;

  UploadAvatarRequested({required this.userId, required this.filePath});

  @override
  List<Object?> get props => [userId, filePath];
}

class DeleteAvatarRequested extends UserEvent {
  final String userId;

  DeleteAvatarRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class SearchUsersRequested extends UserEvent {
  final String? query;
  final City? city;
  final int? limit;

  SearchUsersRequested({this.query, this.city, this.limit});

  @override
  List<Object?> get props => [query, city, limit];
}

class ClearUserRequested extends UserEvent {}
