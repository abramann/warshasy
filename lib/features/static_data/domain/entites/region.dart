// lib/features/database/domain/entities/region.dart
import 'package:equatable/equatable.dart';

class Region extends Equatable {
  final int id;
  final int cityId;
  final String name;
  final bool isActive;

  const Region({
    required this.id,
    required this.cityId,
    required this.name,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [id, cityId, name, isActive];

  Region copyWith({int? id, int? cityId, String? name, bool? isActive}) {
    return Region(
      id: id ?? this.id,
      cityId: cityId ?? this.cityId,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }
}
