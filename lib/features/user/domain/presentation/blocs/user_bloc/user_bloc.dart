import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/features/static_data/domain/entites/location.dart';
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

  Future<void> _onSearchUsers(
    SearchUsersRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    try {
      final users = await userRepository.searchUsers(
        query: event.query,
        location: event.location,
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
