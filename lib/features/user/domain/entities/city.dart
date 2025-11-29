// ============================================
// lib/core/entities/city.dart
// ============================================

enum City {
  damascus('دمشق', 'Damascus'),
  aleppo('حلب', 'Aleppo'),
  homs('حمص', 'Homs'),
  latakia('اللاذقية', 'Latakia'),
  hama('حماة', 'Hama'),
  raqqa('الرقة', 'Raqqa'),
  deirEzZor('دير الزور', 'Deir ez-Zor'),
  alHasakah('الحسكة', 'Al-Hasakah'),
  qamishli('القامشلي', 'Qamishli'),
  daraa('درعا', 'Daraa'),
  asSuwayda('السويداء', 'As-Suwayda'),
  tartus('طرطوس', 'Tartus'),
  idlib('إدلب', 'Idlib');

  final String arabicName;
  final String englishName;

  const City(this.arabicName, this.englishName);

  String get displayName => arabicName;

  static City fromString(String? value) {
    if (value == null) return City.damascus;
    return City.values.firstWhere(
      (city) => city.arabicName == value || city.englishName == value,
      orElse: () => City.damascus,
    );
  }
}
