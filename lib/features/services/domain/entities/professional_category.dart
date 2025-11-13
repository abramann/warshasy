// ============================================
// lib/features/professionals/domain/entities/professional_category.dart
// ============================================
enum ProfessionalCategory {
  craft('أعمال حرفية', 'Craft Work'),
  technical('أعمال تقنية', 'Technical Work'),
  cleaning('تنظيف وخدمات منزلية', 'Cleaning & Home Services');

  final String arabicName;
  final String englishName;

  const ProfessionalCategory(this.arabicName, this.englishName);

  String get displayName => arabicName;

  static ProfessionalCategory fromString(String value) {
    return ProfessionalCategory.values.firstWhere(
      (category) =>
          category.arabicName == value || category.englishName == value,
      orElse: () => ProfessionalCategory.craft,
    );
  }
}
