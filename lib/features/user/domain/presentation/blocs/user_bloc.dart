import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/config/config.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/user/domain/entities/city.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';
import 'package:warshasy/features/user/domain/repositories/user_repository.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc({required this.userRepository}) : super(const UserInitial()) {
    on<LoadUserRequested>(_onLoadUser);
    on<UpdateProfileRequested>(_onUpdateProfile);
    on<UploadAvatarRequested>(_onUploadAvatar);
    on<DeleteAvatarRequested>(_onDeleteAvatar);
    on<SearchUsersRequested>(_onSearchUsers);
    on<ClearUserRequested>(_onClearUser);
  }

  Future<void> _onLoadUser(
    LoadUserRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    try {
      // fallback to logged-in user's phone if userId is null
      final user = await userRepository.getUserById(event.userId);

      if (user != null) {
        emit(UserLoaded(user: user));
      } else {
        emit(UserError(failure: Failure('No user found with this id')));
      }
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    try {
      final user = await userRepository.updateUser(
        userId: event.userId,
        fullName: event.fullName,
        city: event.city,
        avatarUrl: event.avatarUrl,
        bio: event.bio,
      );

      emit(UserUpdated(user: user));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
    }
  }

  Future<void> _onUploadAvatar(
    UploadAvatarRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    try {
      final avatarUrl = await userRepository.uploadAvatar(
        userId: event.userId,
        filePath: event.filePath,
      );

      emit(AvatarUploaded(avatarUrl: avatarUrl));
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
    }
  }

  Future<void> _onDeleteAvatar(
    DeleteAvatarRequested event,
    Emitter<UserState> emit,
  ) async {
    emit(const UserLoading());

    try {
      await userRepository.deleteAvatar(event.userId);
      emit(const AvatarDeleted());
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
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
    emit(const UserInitial());
  }
}
