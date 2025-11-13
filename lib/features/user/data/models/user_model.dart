// ============================================
// lib/core/data/models/user_model.dart
// ============================================

import 'package:warshasy/features/user/domain/entities/city.dart';
import 'package:warshasy/features/user/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.phone,
    required super.fullName,
    super.city,
    super.avatarUrl,
    super.bio,
    super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['phone'] as String,
      fullName: json['full_name'] as String,
      city:
          json['city'] != null ? City.fromString(json['city'] as String) : null,
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
      'phone': phone,
      'full_name': fullName,
      'city': city?.arabicName,
      'avatar_url': avatarUrl,
      'bio': bio,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      phone: entity.phone,
      fullName: entity.fullName,
      city: entity.city,
      avatarUrl: entity.avatarUrl,
      bio: entity.bio,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  UserModel copyWith({
    String? phone,
    String? fullName,
    City? city,
    String? avatarUrl,
    String? bio,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return UserModel(
      phone: phone ?? this.phone,
      fullName: fullName ?? this.fullName,
      city: city ?? this.city,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      bio: bio ?? this.bio,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
