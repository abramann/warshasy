// This represents what a User IS in app (business logic)
// Think of it as a blueprint/contract

import 'package:equatable/equatable.dart';
import 'package:warshasy/features/user/domain/entities/city.dart';

// ============================================
// DOMAIN LAYER
// ============================================

class User extends Equatable {
  final String id;
  final String phone;
  final String fullName;
  final City? city;
  final String? avatarUrl;
  final String? bio;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.phone,
    required this.fullName,
    this.city,
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
    city,
    avatarUrl,
    bio,
    isActive,
    createdAt,
    updatedAt,
  ];
}
