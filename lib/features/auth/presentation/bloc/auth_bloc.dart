import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:warshasy/core/presentation/utils/error_handler_mixin.dart';
import 'package:warshasy/core/usecases/usecase.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/core/config/injection_container.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import '../../auth.dart';
part 'auth_event.dart';
part 'auth_state.dart';

// ============================================
// STEP 7C: BLOC
// lib/features/auth/presentation/bloc/auth_bloc.dart
// ============================================
// BLoC = Business Logic Component
// Receives Events, processes them, emits States

class AuthBloc extends Bloc<AuthEvent, AuthState>
    with ErrorHandlerMixin<AuthState> {
  final SignInUseCase signInUseCase;
  final SignOutUseCase signOutUseCase;
  final GetAuthinticationSessionUseCase getAuthenticationSessionUseCase;
  final SendVerificationCodeUsecase sendVerificationCodeUseCase;

  AuthBloc({
    required this.signInUseCase,
    required this.signOutUseCase,
    required this.getAuthenticationSessionUseCase,
    required this.sendVerificationCodeUseCase,
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
    late Either<Failure, dynamic> result;

    try {
      switch (event) {
        case SignInRequested():
          emit(AuthLoading());

          final session = await signInUseCase(
            SignInParams(phone: event.phone, code: event.code),
          );

          sl.registerSingleton<AuthSession>(session);
          emit(AuthSuccess(session.user!));
          break;

        case SignOutRequested():
          await signOutUseCase(NoParams());
          sl.resetLazySingleton<AuthSession>();

          emit(AuthWaitingUser());
          break;
        case AuthStartup():
          emit(AuthStarting());
          final authSession = await getAuthenticationSessionUseCase(NoParams());
          if (authSession == null)
            emit(Unauthinticated());
          else {
            add(
              SignInRequested(
                phone: authSession!.phone!,
                code: authSession!.otpCode!.toString(),
                context: event.context,
              ),
            );
          }

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
      handleError(failure, event.context); // optional: show snackbar
    }
  }
}
