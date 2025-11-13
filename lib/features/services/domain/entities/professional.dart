// ============================================
// lib/features/professionals/domain/entities/profession.dart
// ============================================
import 'package:equatable/equatable.dart';
import 'package:warshasy/features/services/domain/entities/professional_category.dart';

class Profession extends Equatable {
  final int id;
  final ProfessionalCategory category;
  final String professionName;

  const Profession({
    required this.id,
    required this.category,
    required this.professionName,
  });

  @override
  List<Object> get props => [id, category, professionName];
}
