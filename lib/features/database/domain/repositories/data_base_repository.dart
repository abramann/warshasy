// lib/features/database/domain/repositories/database_repository.dart
import 'package:warshasy/features/database/domain/entites/city.dart';
import 'package:warshasy/features/database/domain/entites/region.dart';
import 'package:warshasy/features/database/domain/entites/service.dart';
import 'package:warshasy/features/database/domain/entites/service_category.dart';

abstract class DatabaseRepository {
  Future<List<City>> getAllCities();
  Future<List<Region>> getRegionsByCity(int cityId);
  Future<List<ServiceCategory>> getAllServiceCategories();
  Future<List<Service>> getServicesByCategory(int categoryId);
}
