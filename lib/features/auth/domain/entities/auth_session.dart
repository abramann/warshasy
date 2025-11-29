import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/user/data/models/user_model.dart';

class AuthSession {
  final String userId;
  final String deviceId;
  final String sessionToken;
  final DateTime? expiresAt;
  final String? fullName;
  final City? city;

  AuthSession({
    required this.userId,
    required this.deviceId,
    required this.sessionToken,
    this.expiresAt,
    this.fullName,
    this.city,
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
      fullName: json['fullName'] as String?,
      city: json['city'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deviceId': deviceId,
      'sessionToken': sessionToken,
      'expiresAt': expiresAt?.toIso8601String(),
      'fullName': fullName,
      'city': city,
    };
  }

  AuthSession copyWith({
    String? userId,
    String? phone,
    String? deviceId,
    String? sessionToken,
    DateTime? expiresAt,
    String? fullName,
    City? city,
  }) {
    return AuthSession(
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      sessionToken: sessionToken ?? this.sessionToken,
      expiresAt: expiresAt ?? this.expiresAt,
      fullName: fullName ?? this.fullName,
      city: city ?? this.city,
    );
  }
}
