import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:warshasy/features/auth/domain/entities/auth_session.dart';
import '../../auth.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthStartup>(_onStartup);
    on<SendVerificationCodeRequested>(_onSendCode);
    on<SignInRequested>(_onSignIn);
    on<SignOutRequested>(_onSignOut);
  }

  Future<void> _onStartup(AuthStartup event, Emitter<AuthState> emit) async {
    emit(AuthLoadingStartup());

    try {
      final session = await authRepository.restoreSession();

      if (session == null) {
        emit(Unauthenticated());
      } else {
        emit(Authenticated(session));
      }
    } catch (e) {
      // if restore fails for any reason, treat as logged out
      emit(Unauthenticated());
    }
  }

  Future<void> _onSendCode(
    SendVerificationCodeRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await authRepository.sendVerificationCode(phone: event.phone);
      emit(VerificationCodeSent(event.phone));
    } catch (e) {
      emit(AuthFailureState('فشل في إرسال رمز التحقق'));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignIn(SignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());

    try {
      final session = await authRepository.signInWithPhone(
        phone: event.phone,
        code: event.code,
      );
      emit(Authenticated(session));
    } catch (e) {
      emit(AuthFailureState('رمز التحقق غير صحيح أو منتهي الصلاحية'));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await authRepository.signOut();
      emit(Unauthenticated());
    } catch (e) {
      // if sign-out fails, still mark as logged out locally
      emit(Unauthenticated());
    }
  }
}
