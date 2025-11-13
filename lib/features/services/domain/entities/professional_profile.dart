// ============================================
// lib/features/professionals/domain/entities/professional_profile.dart
// ============================================
import 'package:equatable/equatable.dart';
import 'package:warshasy/features/user/domain/entities/city.dart';
import 'package:warshasy/features/services/domain/entities/professional.dart';

class ProfessionalProfile extends Equatable {
  final String id;
  final String fullName;
  final String phone;
  final City city;
  final String? avatarUrl;
  final bool isActive;
  final String? description;
  final bool isCreatedByAdmin;
  final double averageRating;
  final int totalReviews;
  final List<Profession> professions;
  final DateTime createdAt;

  const ProfessionalProfile({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.city,
    this.avatarUrl,
    this.isActive = true,
    this.description,
    this.isCreatedByAdmin = false,
    this.averageRating = 0.0,
    this.totalReviews = 0,
    required this.professions,
    required this.createdAt,
  });

  bool get hasMultipleProfessions => professions.length > 1;

  String get primaryProfession =>
      professions.isNotEmpty ? professions.first.professionName : '';

  @override
  List<Object?> get props => [
    id,
    fullName,
    phone,
    city,
    avatarUrl,
    isActive,
    description,
    isCreatedByAdmin,
    averageRating,
    totalReviews,
    professions,
    createdAt,
  ];
}
