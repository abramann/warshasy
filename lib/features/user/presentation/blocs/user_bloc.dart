import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/config/config.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/user/domain/entities/city.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';
import 'package:warshasy/features/user/domain/usecases/check_phone_exists_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/delete_avatar_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/get_user_by_id_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/get_user_by_phone_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/search_users_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/update_user_usecase.dart';
import 'package:warshasy/features/user/domain/usecases/upload_avatar_usecase.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetUserByIdUseCase getUserByIdUseCase;
  final GetUserByPhoneUseCase getUserByPhoneUseCase;
  final UpdateUserUseCase updateUserUseCase;
  final UploadAvatarUseCase uploadAvatarUseCase;
  final DeleteAvatarUseCase deleteAvatarUseCase;
  final SearchUsersUseCase searchUsersUseCase;
  final CheckPhoneExistsUseCase checkPhoneExistsUseCase;

  UserBloc({
    required this.getUserByIdUseCase,
    required this.getUserByPhoneUseCase,
    required this.updateUserUseCase,
    required this.uploadAvatarUseCase,
    required this.deleteAvatarUseCase,
    required this.searchUsersUseCase,
    required this.checkPhoneExistsUseCase,
  }) : super(const UserInitial()) {
    on<LoadUserRequested>(_handleUserRequest);
    on<LoadUserByPhoneRequested>(_handleUserRequest);
    on<UpdateUserRequested>(_handleUserRequest);
    on<UploadAvatarRequested>(_handleUserRequest);
    on<DeleteAvatarRequested>(_handleUserRequest);
    on<SearchUsersRequested>(_handleUserRequest);
    on<CheckPhoneExistsRequested>(_handleUserRequest);
    on<ClearUserRequested>(_handleUserRequest);
  }

  // Generic handler for user requests
  Future<void> _handleUserRequest(
    UserEvent event,
    Emitter<UserState> emit,
  ) async {
    try {
      switch (event) {
        case LoadUserRequested():
          emit(const UserLoading());

          final user = await getUserByIdUseCase(
            GetUserByIdParams(userId: event.userId ?? sl<AuthSession>().phone!),
          );

          emit(UserLoaded(user: user));
          break;

        case LoadUserByPhoneRequested():
          emit(const UserLoading());

          final user = await getUserByPhoneUseCase(
            GetUserByPhoneParams(phone: event.phone),
          );
          if (user != null)
            emit(UserLoaded(user: user));
          else
            throw UserError(
              failure: Failure(
                'No user found with this associated phone number',
              ),
            );
          break;

        case UpdateUserRequested():
          emit(const UserLoading());

          final user = await updateUserUseCase(
            UpdateUserParams(
              userId: event.userId,
              fullName: event.fullName,
              city: event.city,
              avatarUrl: event.avatarUrl,
              bio: event.bio,
            ),
          );
          emit(UserUpdated(user: user));
          break;

        case UploadAvatarRequested():
          emit(const UserLoading());

          final avatarUrl = await uploadAvatarUseCase(
            UploadAvatarParams(userId: event.userId, filePath: event.filePath),
          );
          emit(AvatarUploaded(avatarUrl: avatarUrl));
          break;

        case DeleteAvatarRequested():
          emit(const UserLoading());

          await deleteAvatarUseCase(DeleteAvatarParams(userId: event.userId));
          emit(const AvatarDeleted());
          break;

        case SearchUsersRequested():
          emit(const UserLoading());

          final users = await searchUsersUseCase(
            SearchUsersParams(
              query: event.query,
              city: event.city,
              limit: event.limit,
            ),
          );
          emit(UsersLoaded(users: users));
          break;

        case CheckPhoneExistsRequested():
          emit(const UserLoading());

          final exists = await checkPhoneExistsUseCase(
            CheckPhoneExistsParams(phone: event.phone),
          );
          emit(PhoneExistsChecked(exists: exists));
          break;

        case ClearUserRequested():
          emit(const UserInitial());
          break;
      }
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(UserError(failure: failure));
    }
  }
}

// ============================================
// USAGE EXAMPLES
// ============================================

// Example 1: Load user with error handling
class UserProfilePage extends StatelessWidget {
  final String userId;

  const UserProfilePage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create:
          (context) =>
              sl<UserBloc>()..add(
                LoadUserRequested(
                  userId: userId,
                  context: context, // Pass context for error snackbar
                ),
              ),
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is UserLoaded) {
              return _buildUserProfile(state.user);
            }

            if (state is UserError) {
              // Error is already shown via snackbar if context was provided
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 60,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 16),
                    Text(state.failure.message),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<UserBloc>().add(
                          LoadUserRequested(userId: userId, context: context),
                        );
                      },
                      child: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildUserProfile(User user) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundImage:
                user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
            child:
                user.avatarUrl == null
                    ? const Icon(Icons.person, size: 60)
                    : null,
          ),
          const SizedBox(height: 24),
          Text(user.fullName, style: const TextStyle(fontSize: 24)),
          Text(user.phone),
          if (user.city != null) Text(user.city!.name),
          if (user.bio != null) Text(user.bio!),
        ],
      ),
    );
  }
}

// Example 2: Update user with error handling
class EditProfilePage extends StatefulWidget {
  final String userId;

  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _nameController = TextEditingController();
  final _bioController = TextEditingController();
  City? _selectedCity;

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    context.read<UserBloc>().add(
      UpdateUserRequested(
        userId: widget.userId,
        fullName: _nameController.text.trim(),
        city: _selectedCity,
        bio: _bioController.text.trim(),
        context: context, // Pass context for error handling
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('تعديل الملف الشخصي')),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تحديث الملف الشخصي بنجاح')),
            );
            Navigator.pop(context, state.user);
          }
          // Error is automatically handled by ErrorHandlerMixin
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            final isLoading = state is UserLoading;

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(labelText: 'الاسم'),
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bioController,
                    decoration: const InputDecoration(labelText: 'نبذة'),
                    maxLines: 3,
                    enabled: !isLoading,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveProfile,
                    child:
                        isLoading
                            ? const CircularProgressIndicator()
                            : const Text('حفظ'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
