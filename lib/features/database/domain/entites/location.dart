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

  static const Map<City, List<String>> _regionsByCity = {
    City.damascus: [
      'المزة',
      'المهاجرين',
      'باب توما',
      'القصاع',
      'أبو رمانة',
      'المالكي',
      'كفرسوسة',
      'دمر',
      'برزة',
      'جرمانا',
    ],
    City.aleppo: ['العزيزية', 'الفرقان', 'الحمدانية', 'الشهباء', 'السليمانية'],
    City.homs: ['الوعر', 'الخالدية', 'الحميدية', 'الإنشاءات'],
    City.latakia: ['الزراعة', 'الرمل الجنوبي', 'الطابيات'],
    // Other cities currently have no predefined regions
    City.hama: [],
    City.raqqa: [],
    City.deirEzZor: [],
    City.alHasakah: [],
    City.qamishli: [],
    City.daraa: [],
    City.asSuwayda: [],
    City.tartus: [],
    City.idlib: [],
  };

  const City(this.arabicName, this.englishName);

  String get displayName => arabicName;
  List<String> get regions => _regionsByCity[this] ?? const [];

  static City fromString(String? value) {
    if (value == null) return City.damascus;
    return City.values.firstWhere(
      (city) => city.arabicName == value || city.englishName == value,
      orElse: () => City.damascus,
    );
  }
}

class Location {
  City city;
  String location;
  Location({required this.city, required this.location});

  static Location fromString(String? value) =>
      Location.fromStrings(city: value);

  static Location fromStrings({String? city, String? location}) {
    final cityEnum = City.fromString(city);
    final fallbackLocation =
        location ??
        (cityEnum.regions.isNotEmpty ? cityEnum.regions.first : cityEnum.arabicName);
    return Location(city: cityEnum, location: fallbackLocation);
  }

  static Location get defaultLocation => Location(
    city: City.damascus,
    location: City.damascus.regions.isNotEmpty
        ? City.damascus.regions.first
        : City.damascus.arabicName,
  );

  Map<String, dynamic> toJson() => {
    'city': city.arabicName,
    'location': location,
  };
}
