// lib/features/database/data/models/service_category_model.dart
import 'package:warshasy/features/database/domain/entites/service.dart';
import 'package:warshasy/features/database/domain/entites/service_category.dart';

class ServiceCategoryModel extends ServiceCategory {
  const ServiceCategoryModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    super.description,
    super.iconUrl,
    super.isActive,
    super.services,
  });

  factory ServiceCategoryModel.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      description: json['description'] as String?,
      iconUrl: json['icon_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      services: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'description': description,
      'icon_url': iconUrl,
      'is_active': isActive,
    };
  }

  ServiceCategoryModel copyWithServices(List<Service> services) {
    return ServiceCategoryModel(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      description: description,
      iconUrl: iconUrl,
      isActive: isActive,
      services: services,
    );
  }
}
