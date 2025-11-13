// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  BuildContext context;
  AuthEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

class SignInRequested extends AuthEvent {
  final String phone;
  final String code;

  SignInRequested({
    required this.phone,
    required this.code,
    required super.context,
  });

  @override
  List<Object> get props => [phone, code, super.context];
}

class AuthStartup extends AuthEvent {
  AuthStartup({required super.context});
}

class SignOutRequested extends AuthEvent {
  SignOutRequested({required super.context});
}

class VerificationCodeRequested extends AuthEvent {
  final String phone;

  VerificationCodeRequested({required this.phone, required super.context});

  @override
  List<Object> get props => [phone, super.context];
}
