// lib/features/database/data/models/city_model.dart
import 'package:warshasy/features/static_data/domain/entites/city.dart';
import 'package:warshasy/features/static_data/domain/entites/region.dart';
import 'region_model.dart';

class CityModel extends City {
  const CityModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
    super.isActive,
    super.regions,
  });

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      id: json['id'] as int,
      nameAr: json['name_ar'] as String,
      nameEn: json['name_en'] as String,
      isActive: json['is_active'] as bool? ?? true,
      regions: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name_ar': nameAr,
      'name_en': nameEn,
      'is_active': isActive,
    };
  }

  CityModel copyWithRegions(List<Region> regions) {
    return CityModel(
      id: id,
      nameAr: nameAr,
      nameEn: nameEn,
      isActive: isActive,
      regions: regions,
    );
  }
}
