import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/core/usecases/usecase.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/core/config/injection_container.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import 'package:warshasy/features/auth/domain/usecases/persist_session_use_case.dart';
import '../../auth.dart';
part 'auth_event.dart';
part 'auth_state.dart';

// BLoC = Business Logic Component
// Receives Events, processes them, emits States

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetStoredSessionUseCase getStoredSessionUseCase;
  final SendVerificationCodeUsecase sendVerificationCodeUseCase;
  final RestoreSessionUseCase restoreSessionUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getStoredSessionUseCase,
    required this.sendVerificationCodeUseCase,
    required this.restoreSessionUseCase,
  }) : super(AuthStarting()) {
    on<SignInRequested>(_handleAuthRequest);
    on<SignOutRequested>(_handleAuthRequest);
    on<AuthStartup>(_handleAuthRequest);
    on<VerificationCodeRequested>(_handleAuthRequest);
  }

  // Generic handler for auth requests
  Future<void> _handleAuthRequest(
    AuthEvent event,
    Emitter<AuthState> emit,
  ) async {
    try {
      switch (event) {
        case SignInRequested():
          emit(AuthLoading());

          final session = await signInUseCase(
            SignInParams(phone: event.phone, code: event.code),
          );

          emit(AuthSuccess(session));
          break;

        case SignOutRequested():
          await signOutUseCase(NoParams());
          emit(Unauthinticated());
          break;
        case AuthStartup():
          emit(AuthStarting());

          final session = await restoreSessionUseCase();
          //await persistSessionUseCase(newSession);
          emit(AuthSuccess(session));

          break;
        case VerificationCodeRequested():
          emit(AuthLoading());
          await sendVerificationCodeUseCase(event.phone);
          emit(VerificationCodeSent());
          break;
      }
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(AuthFailureState(failure));
    }
  }
}
