import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/features/user/domain/entities/city.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';
import 'package:warshasy/features/user/domain/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  // Cache the current user to avoid unnecessary API calls
  User? _cachedUser;

  UserBloc({required this.userRepository}) : super(const UserInitial()) {
    on<LoadUserRequested>(_onLoadUser);
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<UploadAvatarRequested>(_onUploadAvatar);
    on<DeleteAvatarRequested>(_onDeleteAvatar);
    on<SearchUsersRequested>(_onSearchUsers);
    on<ClearUserRequested>(_onClearUser);
    on<RefreshUserRequested>(_onRefreshUser);
  }

  Future<void> _onLoadUser(
    LoadUserRequested event,
    Emitter<UserState> emit,
  ) async {
    // If we already have this user loaded and not forcing refresh, return cached
    if (!event.forceRefresh &&
        _cachedUser != null &&
        _cachedUser!.id == event.userId) {
      emit(UserLoaded(user: _cachedUser!));
      return;
    }

    emit(const UserLoading());

    try {
      final user = await userRepository.getUserById(event.userId);
      _cachedUser = user;
      emit(UserLoaded(user: user));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
    }
  }

  Future<void> _onRefreshUser(
    RefreshUserRequested event,
    Emitter<UserState> emit,
  ) async {
    // Force refresh without showing loading state
    try {
      final user = await userRepository.getUserById(event.userId);
      _cachedUser = user;
      emit(UserLoaded(user: user));
    } on Exception catch (e) {
      // Keep the old state if refresh fails
      if (_cachedUser != null) {
        emit(UserLoaded(user: _cachedUser!));
      } else {
        final failure = ErrorMapper.map(e);
        emit(UserError(failure: failure));
      }
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<UserState> emit,
  ) async {
    // Show updating state with current user data
    if (_cachedUser != null) {
      emit(UserUpdating(user: _cachedUser!));
    } else {
      emit(const UserLoading());
    }

    try {
      final user = await userRepository.updateUser(user: event.user);

      _cachedUser = user;
      emit(UserUpdated(user: user));
      // Transition to loaded state after a brief moment
      await Future.delayed(const Duration(milliseconds: 500));
      emit(UserLoaded(user: user));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
      // Return to previous state if available
      if (_cachedUser != null) {
        emit(UserLoaded(user: _cachedUser!));
      }
    }
  }

  Future<void> _onUploadAvatar(
    UploadAvatarRequested event,
    Emitter<UserState> emit,
  ) async {
    if (_cachedUser != null) {
      emit(UserUpdating(user: _cachedUser!));
    } else {
      emit(const UserLoading());
    }

    try {
      final avatarUrl = await userRepository.uploadAvatar(
        userId: event.userId,
        filePath: event.filePath,
      );

      // Reload user to get updated avatar
      final user = await userRepository.getUserById(event.userId);
      _cachedUser = user;

      emit(AvatarUploaded(avatarUrl: avatarUrl, user: user));
      await Future.delayed(const Duration(milliseconds: 500));
      emit(UserLoaded(user: user));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
      if (_cachedUser != null) {
        emit(UserLoaded(user: _cachedUser!));
      }
    }
  }

  Future<void> _onDeleteAvatar(
    DeleteAvatarRequested event,
    Emitter<UserState> emit,
  ) async {
    if (_cachedUser != null) {
      emit(UserUpdating(user: _cachedUser!));
    } else {
      emit(const UserLoading());
    }

    try {
      await userRepository.deleteAvatar(event.userId);

      // Reload user
      final user = await userRepository.getUserById(event.userId);
      _cachedUser = user;

      emit(const AvatarDeleted());
      await Future.delayed(const Duration(milliseconds: 500));
      emit(UserLoaded(user: user));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
      if (_cachedUser != null) {
        emit(UserLoaded(user: _cachedUser!));
      }
    }
  }

  Future<void> _onSearchUsers(
    SearchUsersRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    try {
      final users = await userRepository.searchUsers(
        query: event.query,
        city: event.city,
        limit: event.limit,
      );

      emit(UsersLoaded(users: users));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
    }
  }

  void _onClearUser(ClearUserRequested event, Emitter<UserState> emit) {
    _cachedUser = null;
    emit(const UserInitial());
  }
}
