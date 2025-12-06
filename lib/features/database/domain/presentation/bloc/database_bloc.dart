// lib/features/database/presentation/bloc/database_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/features/database/domain/entites/city.dart';
import 'package:warshasy/features/database/domain/entites/location.dart';
import 'package:warshasy/features/database/domain/entites/region.dart';
import 'package:warshasy/features/database/domain/entites/service.dart';
import 'package:warshasy/features/database/domain/entites/service_category.dart';
import 'package:warshasy/features/database/domain/repositories/data_base_repository.dart';

part 'database_event.dart';
part 'database_state.dart';

class LocationResolver {
  final DatabaseBloc databaseBloc;

  LocationResolver(this.databaseBloc);

  Location? resolveLegacyLocation(Location? location) {
    if (location == null || !location.needsResolution) return location;

    final state = databaseBloc.state;
    if (state is! DatabaseLoaded) return null;

    // Find city by name
    final city = state.getCityByName(location.cityName);
    if (city == null) return null;

    // Find region by name if provided
    Region? region;
    if (location.regionName != null) {
      try {
        region = city.regions.firstWhere((r) => r.name == location.regionName);
      } catch (_) {
        // Region not found, use null
      }
    }

    return Location.fromCityAndRegion(city: city, region: region);
  }
}

class DatabaseBloc extends Bloc<DatabaseEvent, DatabaseState> {
  final DatabaseRepository databaseRepository;

  // Cached data
  List<City>? _cachedCities;
  List<ServiceCategory>? _cachedCategories;

  DatabaseBloc({required this.databaseRepository})
    : super(const DatabaseInitial()) {
    on<LoadDatabaseData>(_onLoadDatabaseData);
    on<RefreshDatabaseData>(_onRefreshDatabaseData);
    on<ClearDatabaseCache>(_onClearDatabaseCache);
  }

  Future<void> _onLoadDatabaseData(
    LoadDatabaseData event,
    Emitter<DatabaseState> emit,
  ) async {
    // If we have cached data and not forcing refresh, return cached
    if (!event.forceRefresh &&
        _cachedCities != null &&
        _cachedCategories != null) {
      emit(
        DatabaseLoaded(
          cities: _cachedCities!,
          serviceCategories: _cachedCategories!,
        ),
      );
      return;
    }

    emit(const DatabaseLoading());

    try {
      // Load cities and service categories in parallel
      final results = await Future.wait([
        databaseRepository.getAllCities(),
        databaseRepository.getAllServiceCategories(),
      ]);

      _cachedCities = results[0] as List<City>;
      _cachedCategories = results[1] as List<ServiceCategory>;

      emit(
        DatabaseLoaded(
          cities: _cachedCities!,
          serviceCategories: _cachedCategories!,
        ),
      );
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(DatabaseError(failure: failure));
    }
  }

  Future<void> _onRefreshDatabaseData(
    RefreshDatabaseData event,
    Emitter<DatabaseState> emit,
  ) async {
    // Force refresh without showing loading state
    try {
      final results = await Future.wait([
        databaseRepository.getAllCities(),
        databaseRepository.getAllServiceCategories(),
      ]);

      _cachedCities = results[0] as List<City>;
      _cachedCategories = results[1] as List<ServiceCategory>;

      emit(
        DatabaseLoaded(
          cities: _cachedCities!,
          serviceCategories: _cachedCategories!,
        ),
      );
    } on Exception catch (e) {
      // Keep the old state if refresh fails
      if (_cachedCities != null && _cachedCategories != null) {
        emit(
          DatabaseLoaded(
            cities: _cachedCities!,
            serviceCategories: _cachedCategories!,
          ),
        );
      } else {
        final failure = ErrorMapper.map(e);
        emit(DatabaseError(failure: failure));
      }
    }
  }

  void _onClearDatabaseCache(
    ClearDatabaseCache event,
    Emitter<DatabaseState> emit,
  ) {
    _cachedCities = null;
    _cachedCategories = null;
    emit(const DatabaseInitial());
  }

  // Helper methods for easy access
  City? getCityById(int id) {
    return _cachedCities?.firstWhere(
      (city) => city.id == id,
      orElse: () => _cachedCities!.first,
    );
  }

  City? getCityByName(String name) {
    return _cachedCities?.firstWhere(
      (city) => city.nameAr == name || city.nameEn == name,
      orElse: () => _cachedCities!.first,
    );
  }

  ServiceCategory? getCategoryById(int id) {
    return _cachedCategories?.firstWhere(
      (category) => category.id == id,
      orElse: () => _cachedCategories!.first,
    );
  }

  Service? getServiceById(int id) {
    for (final category in _cachedCategories ?? []) {
      for (final service in category.services) {
        if (service.id == id) return service;
      }
    }
    return null;
  }
}
