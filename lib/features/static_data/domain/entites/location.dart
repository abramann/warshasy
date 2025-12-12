// lib/features/database/domain/entities/location.dart - UPDATED
import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final int cityId;
  final int? regionId;

  const Location({required this.cityId, this.regionId});

  @override
  List<Object?> get props => [cityId, regionId];

  Location copyWith({int? cityId, int? regionId}) {
    return Location(
      cityId: cityId ?? this.cityId,
      regionId: regionId ?? this.regionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {'city_id': cityId, 'area_id': regionId};
  }

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      cityId: json['city_id'] as int,
      regionId: json['area_id'] as int?,
    );
  }
}
