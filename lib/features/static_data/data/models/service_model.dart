// lib/features/database/data/models/service_model.dart
import 'package:warshasy/features/static_data/domain/entites/service.dart';

class ServiceModel extends Service {
  const ServiceModel({
    required super.id,
    required super.categoryId,
    required super.nameAr,
    required super.nameEn,
    super.description,
    super.isActive,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id'] as int,
      categoryId: json['category_id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'category_id': categoryId,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description': description,
      'is_active': isActive,
    };
  }
}
