import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/database/domain/entites/location.dart';

class AuthSession {
  final String userId;
  final String deviceId;
  final String sessionToken;
  final DateTime? expiresAt;
  AuthSession({
    required this.userId,
    required this.deviceId,
    required this.sessionToken,
    this.expiresAt,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      userId: json['userId'] as String,
      deviceId: json['deviceId'] as String,
      sessionToken: json['sessionToken'] as String,
      expiresAt:
          json['expiresAt'] != null
              ? DateTime.parse(json['expiresAt'] as String)
              : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deviceId': deviceId,
      'sessionToken': sessionToken,
      'expiresAt': expiresAt?.toIso8601String(),
    };
  }

  AuthSession copyWith({
    String? userId,
    String? phone,
    String? deviceId,
    String? sessionToken,
    DateTime? expiresAt,
  }) {
    return AuthSession(
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      sessionToken: sessionToken ?? this.sessionToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
