// lib/features/database/domain/entities/service.dart
import 'package:equatable/equatable.dart';

class Service extends Equatable {
  final int id;
  final int categoryId;
  final String nameAr;
  final String nameEn;
  final String? description;
  final bool isActive;

  const Service({
    required this.id,
    required this.categoryId,
    required this.nameAr,
    required this.nameEn,
    this.description,
    this.isActive = true,
  });

  @override
  List<Object?> get props => [
    id,
    categoryId,
    nameAr,
    nameEn,
    description,
    isActive,
  ];

  Service copyWith({
    int? id,
    int? categoryId,
    String? nameAr,
    String? nameEn,
    String? description,
    bool? isActive,
  }) {
    return Service(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
    );
  }
}
