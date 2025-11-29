part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// Load user by ID
class LoadUserRequested extends UserEvent {
  final String userId;

  LoadUserRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// Update user profile
class UpdateProfileRequested extends UserEvent {
  final String userId;
  final String fullName;
  final String phone;
  final City? city;
  final String? avatarUrl;
  final String? bio;

  UpdateProfileRequested({
    required this.userId,
    required this.fullName,
    required this.phone,
    this.city,
    this.avatarUrl,
    this.bio,
  });

  @override
  List<Object?> get props => [userId, fullName, city, avatarUrl, bio];
}

// Upload avatar
class UploadAvatarRequested extends UserEvent {
  final String userId;
  final String filePath;

  UploadAvatarRequested({required this.userId, required this.filePath});

  @override
  List<Object?> get props => [userId, filePath];
}

// Delete avatar
class DeleteAvatarRequested extends UserEvent {
  final String userId;

  DeleteAvatarRequested({required this.userId});

  @override
  List<Object?> get props => [userId];
}

// Search users
class SearchUsersRequested extends UserEvent {
  final String? query;
  final City? city;
  final int? limit;

  SearchUsersRequested({this.query, this.city, this.limit});

  @override
  List<Object?> get props => [query, city, limit];
}

// Check if phone exists
class CheckPhoneExistsRequested extends UserEvent {
  final String phone;

  CheckPhoneExistsRequested({required this.phone});

  @override
  List<Object?> get props => [phone];
}

// Clear user data
class ClearUserRequested extends UserEvent {}
