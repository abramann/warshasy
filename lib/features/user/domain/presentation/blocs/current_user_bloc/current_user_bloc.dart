// lib/features/user/domain/presentation/blocs/current_user_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';
import 'package:warshasy/features/user/domain/repositories/user_repository.dart';

part 'current_user_event.dart';
part 'current_user_state.dart';

class CurrentUserBloc extends Bloc<CurrentUserEvent, CurrentUserState> {
  final UserRepository userRepository;

  // Cache the current user
  User? _currentUser;

  CurrentUserBloc({required this.userRepository})
    : super(const CurrentUserInitial()) {
    on<LoadCurrentUser>(_onLoadCurrentUser);
    on<UpdateCurrentUser>(_onUpdateCurrentUser);
    on<UploadCurrentUserAvatar>(_onUploadAvatar);
    on<DeleteCurrentUserAvatar>(_onDeleteAvatar);
    on<RefreshCurrentUser>(_onRefreshCurrentUser);
    on<ClearCurrentUser>(_onClearCurrentUser);
  }

  Future<void> _onLoadCurrentUser(
    LoadCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) async {
    // If we already have user loaded and not forcing refresh, return cached
    if (!event.forceRefresh && _currentUser != null) {
      emit(CurrentUserLoaded(user: _currentUser!));
      return;
    }

    emit(const CurrentUserLoading());

    try {
      final user = await userRepository.getUserById(event.userId);
      _currentUser = user;
      emit(CurrentUserLoaded(user: user));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(CurrentUserError(failure: failure));
    }
  }

  Future<void> _onRefreshCurrentUser(
    RefreshCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) async {
    // Refresh without showing loading state
    try {
      final user = await userRepository.getUserById(event.userId);
      _currentUser = user;
      emit(CurrentUserLoaded(user: user));
    } on Exception catch (e) {
      // Keep old state if refresh fails
      if (_currentUser != null) {
        emit(CurrentUserLoaded(user: _currentUser!));
      } else {
        final failure = ErrorMapper.map(e);
        emit(CurrentUserError(failure: failure));
      }
    }
  }

  Future<void> _onUpdateCurrentUser(
    UpdateCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) async {
    // Show updating state with current user
    if (_currentUser != null) {
      emit(CurrentUserUpdating(user: _currentUser!));
    } else {
      emit(const CurrentUserLoading());
    }

    try {
      final user = await userRepository.updateUser(user: event.user);
      _currentUser = user;

      emit(CurrentUserUpdated(user: user));
      // Transition to loaded after brief moment
      await Future.delayed(const Duration(milliseconds: 500));
      emit(CurrentUserLoaded(user: user));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(CurrentUserError(failure: failure));
      // Return to previous state if available
      if (_currentUser != null) {
        emit(CurrentUserLoaded(user: _currentUser!));
      }
    }
  }

  Future<void> _onUploadAvatar(
    UploadCurrentUserAvatar event,
    Emitter<CurrentUserState> emit,
  ) async {
    if (_currentUser != null) {
      emit(CurrentUserUpdating(user: _currentUser!));
    } else {
      emit(const CurrentUserLoading());
    }

    try {
      final avatarUrl = await userRepository.uploadAvatar(
        userId: _currentUser!.id,
        filePath: event.filePath,
      );

      // Reload user to get updated avatar
      final user = await userRepository.getUserById(_currentUser!.id);
      _currentUser = user;

      emit(CurrentUserAvatarUploaded(avatarUrl: avatarUrl, user: user));
      await Future.delayed(const Duration(milliseconds: 500));
      emit(CurrentUserLoaded(user: user));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(CurrentUserError(failure: failure));
      if (_currentUser != null) {
        emit(CurrentUserLoaded(user: _currentUser!));
      }
    }
  }

  Future<void> _onDeleteAvatar(
    DeleteCurrentUserAvatar event,
    Emitter<CurrentUserState> emit,
  ) async {
    if (_currentUser != null) {
      emit(CurrentUserUpdating(user: _currentUser!));
    } else {
      emit(const CurrentUserLoading());
    }

    try {
      await userRepository.deleteAvatar(event.userId);

      // Reload user
      final user = await userRepository.getUserById(event.userId);
      _currentUser = user;

      emit(CurrentUserAvatarDeleted(user: _currentUser!));
      await Future.delayed(const Duration(milliseconds: 500));
      emit(CurrentUserLoaded(user: user));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(CurrentUserError(failure: failure));
      if (_currentUser != null) {
        emit(CurrentUserLoaded(user: _currentUser!));
      }
    }
  }

  void _onClearCurrentUser(
    ClearCurrentUser event,
    Emitter<CurrentUserState> emit,
  ) {
    _currentUser = null;
    emit(const CurrentUserClear());
  }

  // Helper getter to access current user
  User? get currentUser => _currentUser;
}
