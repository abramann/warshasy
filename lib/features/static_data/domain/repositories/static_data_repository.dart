// lib/features/database/domain/repositories/database_repository.dart
import 'package:warshasy/features/static_data/domain/entites/city.dart';
import 'package:warshasy/features/static_data/domain/entites/region.dart';
import 'package:warshasy/features/static_data/domain/entites/service.dart';
import 'package:warshasy/features/static_data/domain/entites/service_category.dart';

abstract class StaticDataRepository {
  // Cities and Regions
  Future<List<City>> getAllCities();
  Future<List<Region>> getRegionsByCity(int cityId);
  Future<List<ServiceCategory>> getAllServiceCategories();
  Future<List<Service>> getServicesByCategory(int categoryId);
}
