// lib/features/database/data/repositories/database_repository_impl.dart
import 'package:warshasy/features/database/data/datasources/database_remote_datasource.dart';
import 'package:warshasy/features/database/data/models/city_model.dart';
import 'package:warshasy/features/database/data/models/service_category_model.dart';
import 'package:warshasy/features/database/domain/entites/city.dart';
import 'package:warshasy/features/database/domain/entites/region.dart';
import 'package:warshasy/features/database/domain/entites/service.dart';
import 'package:warshasy/features/database/domain/repositories/data_base_repository.dart';

class DatabaseRepositoryImpl implements DatabaseRepository {
  final DatabaseRemoteDataSource remoteDataSource;

  DatabaseRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<City>> getAllCities() async {
    final cities = await remoteDataSource.getAllCities();
    final regions = await remoteDataSource.getAllRegions();

    // Group regions by city
    final citiesWithRegions = <CityModel>[];
    for (final city in cities) {
      final cityRegions =
          regions.where((region) => region.cityId == city.id).toList();
      citiesWithRegions.add(city.copyWithRegions(cityRegions));
    }

    return citiesWithRegions;
  }

  @override
  Future<List<Region>> getRegionsByCity(int cityId) async {
    return await remoteDataSource.getRegionsByCity(cityId);
  }

  @override
  Future<List<ServiceCategoryModel>> getAllServiceCategories() async {
    final categories = await remoteDataSource.getAllServiceCategories();
    final services = await remoteDataSource.getAllServices();

    // Group services by category
    final categoriesWithServices = <ServiceCategoryModel>[];
    for (final category in categories) {
      final categoryServices =
          services
              .where((service) => service.categoryId == category.id)
              .toList();
      categoriesWithServices.add(category.copyWithServices(categoryServices));
    }

    return categoriesWithServices;
  }

  @override
  Future<List<Service>> getServicesByCategory(int categoryId) async {
    return await remoteDataSource.getServicesByCategory(categoryId);
  }
}
