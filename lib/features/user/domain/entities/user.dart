// This represents what a User IS in your app (business logic)
// Think of it as a blueprint/contract

import 'package:equatable/equatable.dart';
import 'package:warshasy/features/user/domain/entities/city.dart';

// ============================================
// DOMAIN LAYER
// ============================================

class User extends Equatable {
  final String phone;
  final String fullName;
  final City? city;
  final String? avatarUrl;
  final String? bio;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.phone,
    required this.fullName,
    this.city,
    this.avatarUrl,
    this.bio,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
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
