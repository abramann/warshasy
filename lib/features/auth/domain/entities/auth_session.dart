import 'package:warshasy/features/auth/auth.dart';
import 'package:warshasy/features/database/domain/entites/location.dart';

class AuthSession {
  final String userId;
  final String deviceId;
  final String sessionToken;
  final DateTime? expiresAt;
  final String? fullName;
  final Location? location;

  AuthSession({
    required this.userId,
    required this.deviceId,
    required this.sessionToken,
    this.expiresAt,
    this.fullName,
    this.location,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    final rawLocation = json['location'];
    Location? parsedLocation;
    if (rawLocation is Map<String, dynamic>) {
      parsedLocation = Location.fromStrings(
        city: rawLocation['city'] as String?,
        location: rawLocation['location'] as String?,
      );
    } else {
      final cityValue = json['city'] as String?;
      final locationValue = json['location'] as String?;
      if (cityValue != null || locationValue != null) {
        parsedLocation = Location.fromStrings(
          city: cityValue,
          location: locationValue,
        );
      }
    }

    return AuthSession(
      userId: json['userId'] as String,
      deviceId: json['deviceId'] as String,
      sessionToken: json['sessionToken'] as String,
      expiresAt:
          json['expiresAt'] != null
              ? DateTime.parse(json['expiresAt'] as String)
              : null,
      fullName: json['fullName'] as String?,
      location: parsedLocation,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'deviceId': deviceId,
      'sessionToken': sessionToken,
      'expiresAt': expiresAt?.toIso8601String(),
      'fullName': fullName,
      'city': location?.city.arabicName,
      'location': location?.toJson(),
    };
  }

  AuthSession copyWith({
    String? userId,
    String? phone,
    String? deviceId,
    String? sessionToken,
    DateTime? expiresAt,
    String? fullName,
    Location? location,
  }) {
    return AuthSession(
      userId: userId ?? this.userId,
      deviceId: deviceId ?? this.deviceId,
      sessionToken: sessionToken ?? this.sessionToken,
      expiresAt: expiresAt ?? this.expiresAt,
      fullName: fullName ?? this.fullName,
      location: location ?? this.location,
    );
  }
}
