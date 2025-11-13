// ============================================
// lib/features/professionals/data/models/profession_model.dart
// ============================================

import 'package:warshasy/features/services/domain/entities/professional.dart';
import 'package:warshasy/features/services/domain/entities/professional_category.dart';

class ProfessionModel extends Profession {
  const ProfessionModel({
    required super.id,
    required super.category,
    required super.professionName,
  });

  factory ProfessionModel.fromJson(Map<String, dynamic> json) {
    return ProfessionModel(
      id: json['profession_id'] as int? ?? json['id'] as int,
      category: ProfessionalCategory.fromString(
        json['home_category'] as String,
      ),
      professionName: json['profession'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'home_category': category.arabicName,
      'profession': professionName,
    };
  }

  factory ProfessionModel.fromEntity(Profession entity) {
    return ProfessionModel(
      id: entity.id,
      category: entity.category,
      professionName: entity.professionName,
    );
  }
}
