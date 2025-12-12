// This represents what a User IS in app (business logic)
// Think of it as a blueprint/contract

import 'package:equatable/equatable.dart';
import 'package:warshasy/features/static_data/domain/entites/location.dart';

// ============================================
// DOMAIN LAYER
// ============================================

class User extends Equatable {
  final String id;
  final String phone;
  final String fullName;
  final Location location;
  final String? avatarUrl;
  final String? bio;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.phone,
    required this.fullName,
    required this.location,
    this.avatarUrl,
    this.bio,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    phone,
    fullName,
    location,
    avatarUrl,
    bio,
    isActive,
    createdAt,
    updatedAt,
  ];

  User copyWith({
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
    return User(
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
