import 'package:warshasy/features/auth/auth.dart';

class AuthSession {
  String phone;
  int otpCode;
  User? user;

  AuthSession({required this.phone, required this.otpCode, required this.user});

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
    phone: json['phone'] as String,
    otpCode: json['code'] as int,
    user: null,
  );

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'code': otpCode};
  }
}
