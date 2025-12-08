part of 'static_data_bloc.dart';

abstract class StaticDataState extends Equatable {
  const StaticDataState();

  @override
  List<Object?> get props => [];
}

class StaticDataInitial extends StaticDataState {
  const StaticDataInitial();
}

class StaticDataLoading extends StaticDataState {
  const StaticDataLoading();
}

class StaticDataLoaded extends StaticDataState {
  final List<City> cities;
  final List<ServiceCategory> serviceCategories;

  const StaticDataLoaded({
    required this.cities,
    required this.serviceCategories,
  });

  @override
  List<Object?> get props => [cities, serviceCategories];

  // Helper getters
  List<Region> get allRegions {
    return cities.expand((city) => city.regions).toList();
  }

  List<Service> get allServices {
    return serviceCategories.expand((category) => category.services).toList();
  }

  City? getCityById(int id) {
    try {
      return cities.firstWhere((city) => city.id == id);
    } catch (_) {
      return null;
    }
  }

  City? getCityByName(String name) {
    try {
      return cities.firstWhere(
        (city) => city.nameAr == name || city.nameEn == name,
      );
    } catch (_) {
      return null;
    }
  }

  ServiceCategory? getCategoryById(int id) {
    try {
      return serviceCategories.firstWhere((cat) => cat.id == id);
    } catch (_) {
      return null;
    }
  }

  Service? getServiceById(int id) {
    for (final category in serviceCategories) {
      try {
        return category.services.firstWhere((s) => s.id == id);
      } catch (_) {
        continue;
      }
    }
    return null;
  }

  List<Region> getRegionsByCity(int cityId) {
    final city = getCityById(cityId);
    return city?.regions ?? [];
  }

  List<Service> getServicesByCategory(int categoryId) {
    final category = getCategoryById(categoryId);
    return category?.services ?? [];
  }
}

class StaticDataError extends StaticDataState {
  final Failure failure;

  const StaticDataError({required this.failure});

  @override
  List<Object?> get props => [failure];
}
