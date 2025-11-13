part of 'user_bloc.dart';

abstract class UserEvent extends Equatable {
  final BuildContext? context;

  const UserEvent({this.context});

  @override
  List<Object?> get props => [context];
}

// Load user by ID
class LoadUserRequested extends UserEvent {
  final String? userId;

  const LoadUserRequested({required this.userId, super.context});

  @override
  List<Object?> get props => [userId, context];
}

// Load user by phone
class LoadUserByPhoneRequested extends UserEvent {
  final String phone;

  const LoadUserByPhoneRequested({required this.phone, super.context});

  @override
  List<Object?> get props => [phone, context];
}

// Update user profile
class UpdateUserRequested extends UserEvent {
  final String userId;
  final String? fullName;
  final City? city;
  final String? avatarUrl;
  final String? bio;

  const UpdateUserRequested({
    required this.userId,
    this.fullName,
    this.city,
    this.avatarUrl,
    this.bio,
    super.context,
  });

  @override
  List<Object?> get props => [userId, fullName, city, avatarUrl, bio, context];
}

// Upload avatar
class UploadAvatarRequested extends UserEvent {
  final String userId;
  final String filePath;

  const UploadAvatarRequested({
    required this.userId,
    required this.filePath,
    super.context,
  });

  @override
  List<Object?> get props => [userId, filePath, context];
}

// Delete avatar
class DeleteAvatarRequested extends UserEvent {
  final String userId;

  const DeleteAvatarRequested({required this.userId, super.context});

  @override
  List<Object?> get props => [userId, context];
}

// Search users
class SearchUsersRequested extends UserEvent {
  final String? query;
  final City? city;
  final int? limit;

  const SearchUsersRequested({
    this.query,
    this.city,
    this.limit,
    super.context,
  });

  @override
  List<Object?> get props => [query, city, limit, context];
}

// Check if phone exists
class CheckPhoneExistsRequested extends UserEvent {
  final String phone;

  const CheckPhoneExistsRequested({required this.phone, super.context});

  @override
  List<Object?> get props => [phone, context];
}

// Clear user data
class ClearUserRequested extends UserEvent {
  const ClearUserRequested({super.context});
}
