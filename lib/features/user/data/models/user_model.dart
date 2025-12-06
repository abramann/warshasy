// ============================================
// lib/core/data/models/user_model.dart
// ============================================

import 'package:warshasy/features/database/domain/entites/location.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.phone,
    required super.fullName,
    super.location,
    super.avatarUrl,
    super.bio,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final cityValue = json['city'] as String?;
    final locationValue = json['location'] as String?;

    return UserModel(
      id: json['id'] as String,
      phone: json['phone'] as String,
      fullName: json['full_name'] as String,
      location:
          (cityValue != null || locationValue != null)
              ? Location.fromStrings(city: cityValue, location: locationValue)
              : null,
      avatarUrl: json['avatar_url'] as String?,
      bio: json['bio'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt:
          json['updated_at'] != null
              ? DateTime.parse(json['updated_at'] as String)
              : DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'full_name': fullName,
      'city': location?.city.arabicName,
      'location': location?.location,
      'avatar_url': avatarUrl,
      'bio': bio,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      phone: entity.phone,
      fullName: entity.fullName,
      location: entity.location,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserModel copyWith({
    String? id,
    String? phone,
    String? fullName,
    Location? location,
    String? avatarUrl,
    String? bio,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
