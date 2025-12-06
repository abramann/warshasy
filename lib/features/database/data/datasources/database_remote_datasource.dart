// lib/features/database/data/datasources/database_remote_datasource.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:warshasy/core/network/network.dart';
import 'package:warshasy/core/utils/injection_container.dart';
import '../models/city_model.dart';
import '../models/region_model.dart';
import '../models/service_category_model.dart';
import '../models/service_model.dart';

abstract class DatabaseRemoteDataSource {
  Future<List<CityModel>> getAllCities();
  Future<List<RegionModel>> getRegionsByCity(int cityId);
  Future<List<RegionModel>> getAllRegions();
  Future<List<ServiceCategoryModel>> getAllServiceCategories();
  Future<List<ServiceModel>> getServicesByCategory(int categoryId);
  Future<List<ServiceModel>> getAllServices();
}

class DatabaseRemoteDataSourceImpl implements DatabaseRemoteDataSource {
  final SupabaseClient supabaseClient;
  final network = sl<Network>();

  DatabaseRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<List<CityModel>> getAllCities() async {
    return await network.guard(() async {
      final response = await supabaseClient
          .from('cities')
          .select()
          .eq('is_active', true)
          .order('name_ar', ascending: true);

      return (response as List)
          .map((json) => CityModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<RegionModel>> getRegionsByCity(int cityId) async {
    return await network.guard(() async {
      final response = await supabaseClient
          .from('city_areas')
          .select()
          .eq('city_id', cityId)
          .eq('is_active', true)
          .order('area_name', ascending: true);

      return (response as List)
          .map((json) => RegionModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<RegionModel>> getAllRegions() async {
    return await network.guard(() async {
      final response = await supabaseClient
          .from('city_areas')
          .select()
          .eq('is_active', true)
          .order('city_id, area_name', ascending: true);

      return (response as List)
          .map((json) => RegionModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<ServiceCategoryModel>> getAllServiceCategories() async {
    return await network.guard(() async {
      final response = await supabaseClient
          .from('service_categories')
          .select()
          .eq('is_active', true)
          .order('display_order, name_ar', ascending: true);

      return (response as List)
          .map((json) => ServiceCategoryModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<ServiceModel>> getServicesByCategory(int categoryId) async {
    return await network.guard(() async {
      final response = await supabaseClient
          .from('services')
          .select()
          .eq('category_id', categoryId)
          .eq('is_active', true)
          .order('name_ar', ascending: true);

      return (response as List)
          .map((json) => ServiceModel.fromJson(json))
          .toList();
    });
  }

  @override
  Future<List<ServiceModel>> getAllServices() async {
    return await network.guard(() async {
      final response = await supabaseClient
          .from('services')
          .select()
          .eq('is_active', true)
          .order('category_id, name_ar', ascending: true);

      return (response as List)
          .map((json) => ServiceModel.fromJson(json))
          .toList();
    });
  }
}
