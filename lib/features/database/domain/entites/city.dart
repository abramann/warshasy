// lib/features/database/domain/entities/city.dart
import 'package:equatable/equatable.dart';
import 'package:warshasy/features/database/domain/entites/region.dart';

class City extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;
  final bool isActive;
  final List<Region> regions;

  const City({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.isActive = true,
    this.regions = const [],
  });

  @override
  List<Object?> get props => [id, nameAr, nameEn, isActive, regions];

  City copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    bool? isActive,
    List<Region>? regions,
  }) {
    return City(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      isActive: isActive ?? this.isActive,
      regions: regions ?? this.regions,
    );
  }
}
