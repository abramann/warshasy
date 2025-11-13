// ============================================
// lib/features/professionals/data/models/professional_profile_model.dart
// ============================================
import 'package:warshasy/features/user/domain/entities/city.dart';
import '../../domain/entities/professional_profile.dart';
import 'profession_model.dart';

class ProfessionalProfileModel extends ProfessionalProfile {
  const ProfessionalProfileModel({
    required super.id,
    required super.fullName,
    required super.phone,
    required super.city,
    super.avatarUrl,
    super.isActive,
    super.description,
    super.isCreatedByAdmin,
    super.averageRating,
    super.totalReviews,
    required super.professions,
    required super.createdAt,
  });

  factory ProfessionalProfileModel.fromJson(Map<String, dynamic> json) {
    // Parse professions list
    List<ProfessionModel> professionsList = [];
    if (json['professions'] != null) {
      professionsList =
          (json['professions'] as List)
              .map((p) => ProfessionModel.fromJson(p as Map<String, dynamic>))
              .toList();
    }

    return ProfessionalProfileModel(
      id: json['user_id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      city: City.fromString(json['city'] as String),

      avatarUrl: json['avatar_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      description: json['profile_description'] as String?,
      isCreatedByAdmin: json['is_created_by_admin'] as bool? ?? false,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      totalReviews: json['total_reviews'] as int? ?? 0,
      professions: professionsList,
      createdAt: DateTime.parse(json['user_created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': id,
      'full_name': fullName,
      'phone': phone,
      'city': city.arabicName,
      'avatar_url': avatarUrl,
      'is_active': isActive,
      'profile_description': description,
      'is_created_by_admin': isCreatedByAdmin,
      'average_rating': averageRating,
      'total_reviews': totalReviews,
      'professions':
          professions
              .map(
                (p) => {
                  'profession_id': p.id,
                  'profession': p.professionName,
                  'category': p.category.arabicName,
                },
              )
              .toList(),
      'user_created_at': createdAt.toIso8601String(),
    };
  }

  factory ProfessionalProfileModel.fromEntity(ProfessionalProfile entity) {
    return ProfessionalProfileModel(
      id: entity.id,
      fullName: entity.fullName,
      phone: entity.phone,
      city: entity.city,
      avatarUrl: entity.avatarUrl,
      isActive: entity.isActive,
      description: entity.description,
      isCreatedByAdmin: entity.isCreatedByAdmin,
      averageRating: entity.averageRating,
      totalReviews: entity.totalReviews,
      professions: entity.professions,
      createdAt: entity.createdAt,
    );
  }

  ProfessionalProfileModel copyWith({
    String? id,
    String? fullName,
    String? phone,
    City? city,
    String? avatarUrl,
    bool? isActive,
    String? description,
    bool? isCreatedByAdmin,
    double? averageRating,
    int? totalReviews,
    List<ProfessionModel>? professions,
    DateTime? createdAt,
  }) {
    return ProfessionalProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
      isCreatedByAdmin: isCreatedByAdmin ?? this.isCreatedByAdmin,
      averageRating: averageRating ?? this.averageRating,
      totalReviews: totalReviews ?? this.totalReviews,
      professions: professions ?? this.professions,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
