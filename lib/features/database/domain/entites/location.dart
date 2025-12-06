// lib/features/database/domain/entities/location.dart - UPDATED
import 'package:equatable/equatable.dart';
import 'package:warshasy/features/database/domain/entites/region.dart';
import 'city.dart';

class Location extends Equatable {
  final int cityId;
  final String cityName;
  final int? regionId;
  final String? regionName;

  const Location({
    required this.cityId,
    required this.cityName,
    this.regionId,
    this.regionName,
  });

  @override
  List<Object?> get props => [cityId, cityName, regionId, regionName];

  Location copyWith({
    int? cityId,
    String? cityNameAr,
    int? regionId,
    String? regionName,
  }) {
    return Location(
      cityId: cityId ?? this.cityId,
      cityName: cityNameAr ?? this.cityName,
      regionId: regionId ?? this.regionId,
      regionName: regionName ?? this.regionName,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'city_id': cityId,
      'city_name': cityName,
      'region_id': regionId,
      'region_name': regionName,
    };
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      cityId: json['city_id'] as int,
      cityName: json['city_name'] as String,
      regionId: json['region_id'] as int?,
      regionName: json['region_name'] as String?,
    );
  }

  // Create from City and optional Region
  factory Location.fromCityAndRegion({required City city, Region? region}) {
    return Location(
      cityId: city.id,
      cityName: city.nameAr,
      regionId: region?.id,
      regionName: region?.name,
    );
  }
  bool get needsResolution => cityId == 0;
}
