// lib/features/database/domain/entities/service_category.dart
import 'package:equatable/equatable.dart';
import 'package:warshasy/features/static_data/domain/entites/service.dart';

class ServiceCategory extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;
  final String? description;
  final String? iconUrl;
  final bool isActive;
  final List<Service> services;

  const ServiceCategory({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    this.description,
    this.iconUrl,
    this.isActive = true,
    this.services = const [],
  });

  @override
  List<Object?> get props => [
    id,
    nameAr,
    nameEn,
    description,
    iconUrl,
    isActive,
    services,
  ];

  ServiceCategory copyWith({
    int? id,
    String? nameAr,
    String? nameEn,
    String? description,
    String? iconUrl,
    bool? isActive,
    List<Service>? services,
  }) {
    return ServiceCategory(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      iconUrl: iconUrl ?? this.iconUrl,
      isActive: isActive ?? this.isActive,
      services: services ?? this.services,
    );
  }
}
