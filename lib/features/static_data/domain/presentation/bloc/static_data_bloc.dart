// lib/features/database/presentation/bloc/database_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:warshasy/core/errors/errors.dart';
import 'package:warshasy/features/static_data/domain/entites/city.dart';
import 'package:warshasy/features/static_data/domain/entites/location.dart';
import 'package:warshasy/features/static_data/domain/entites/region.dart';
import 'package:warshasy/features/static_data/domain/entites/service.dart';
import 'package:warshasy/features/static_data/domain/entites/service_category.dart';
import 'package:warshasy/features/static_data/domain/repositories/static_data_repository.dart';

part 'static_data_event.dart';
part 'static_data_state.dart';

class StaticDataBloc extends Bloc<StaticDataEvent, StaticDataState> {
  final StaticDataRepository staticDataRepository;

  // Cached data
  List<City>? _cachedCities;
  List<ServiceCategory>? _cachedCategories;

  StaticDataBloc({required this.staticDataRepository})
    : super(const StaticDataInitial()) {
    on<LoadStaticData>(_onLoadStaticData);
    on<RefreshStaticData>(_onRefreshStaticData);
    on<ClearStaticDataCache>(_onClearStaticDataCache);
  }

  Future<void> _onLoadStaticData(
    LoadStaticData event,
    Emitter<StaticDataState> emit,
  ) async {
    // If we have cached data and not forcing refresh, return cached
    if (!event.forceRefresh &&
        _cachedCities != null &&
        _cachedCategories != null) {
      emit(
        StaticDataLoaded(
          cities: _cachedCities!,
          serviceCategories: _cachedCategories!,
        ),
      );
      return;
    }

    emit(const StaticDataLoading());

    try {
      // Load cities and service categories in parallel
      final results = await Future.wait([
        staticDataRepository.getAllCities(),
        staticDataRepository.getAllServiceCategories(),
      ]);

      _cachedCities = results[0] as List<City>;
      _cachedCategories = results[1] as List<ServiceCategory>;

      emit(
        StaticDataLoaded(
          cities: _cachedCities!,
          serviceCategories: _cachedCategories!,
        ),
      );
    } on Exception catch (e) {
      final failure = ErrorMapper.map(e);
      emit(StaticDataError(failure: failure));
    }
  }

  Future<void> _onRefreshStaticData(
    RefreshStaticData event,
    Emitter<StaticDataState> emit,
  ) async {
    // Force refresh without showing loading state
    try {
      final results = await Future.wait([
        staticDataRepository.getAllCities(),
        staticDataRepository.getAllServiceCategories(),
      ]);

      _cachedCities = results[0] as List<City>;
      _cachedCategories = results[1] as List<ServiceCategory>;

      emit(
        StaticDataLoaded(
          cities: _cachedCities!,
          serviceCategories: _cachedCategories!,
        ),
      );
    } on Exception catch (e) {
      // Keep the old state if refresh fails
      if (_cachedCities != null && _cachedCategories != null) {
        emit(
          StaticDataLoaded(
            cities: _cachedCities!,
            serviceCategories: _cachedCategories!,
          ),
        );
      } else {
        final failure = ErrorMapper.map(e);
        emit(StaticDataError(failure: failure));
      }
    }
  }

  void _onClearStaticDataCache(
    ClearStaticDataCache event,
    Emitter<StaticDataState> emit,
  ) {
    _cachedCities = null;
    _cachedCategories = null;
    emit(const StaticDataInitial());
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
