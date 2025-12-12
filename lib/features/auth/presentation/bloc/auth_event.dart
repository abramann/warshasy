// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SignInRequested extends AuthEvent {
  final String sessionId;
  final String code;

  SignInRequested({required this.sessionId, required this.code});

  @override
  List<Object> get props => [sessionId, code];
}

class AuthStartup extends AuthEvent {}

class SignOutRequested extends AuthEvent {}

class SendVerificationCodeRequested extends AuthEvent {
  final String phone;

  SendVerificationCodeRequested({required this.phone});

  @override
  List<Object> get props => [phone];
}
