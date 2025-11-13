part of 'auth_bloc.dart';

// ============================================
// STEP 7B: STATES
// lib/features/auth/presentation/bloc/auth_state.dart
// ============================================
// States = Current situation of authentication
// Think: "Is user logged in? Loading? Error?"

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthStarting extends AuthState {}

class AuthWaitingUser extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user; // or User if you have a model
  const AuthSuccess(this.user);
}

class Unauthinticated extends AuthState {}

class AuthFailureState extends AuthState {
  final Failure failure;
  const AuthFailureState(this.failure);
}

class VerificationCodeSent extends AuthState {}
