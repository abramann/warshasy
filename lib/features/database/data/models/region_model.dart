// lib/features/database/data/models/region_model.dart
import 'package:warshasy/features/database/domain/entites/region.dart';

class RegionModel extends Region {
  const RegionModel({
    required super.id,
    required super.cityId,
    required super.name,
    super.isActive,
  });

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    return RegionModel(
      id: json['id'] as int,
      cityId: json['city_id'] as int,
      name: json['area_name'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city_id': cityId,
      'area_name': name,
      'is_active': isActive,
    };
  }
}
