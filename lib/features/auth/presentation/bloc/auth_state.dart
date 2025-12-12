part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthLoadingStartup extends AuthLoading {}

class Authenticated extends AuthState {
  final AuthSession session;
  Authenticated(this.session);
}

class Unauthenticated extends AuthState {}

class AuthFailureState extends AuthState {
  final String message;
  AuthFailureState(this.message);
}

class VerificationCodeSent extends AuthState {
  final String phone;
  final String otpSessionId;

  VerificationCodeSent({required this.phone, required this.otpSessionId});
}
