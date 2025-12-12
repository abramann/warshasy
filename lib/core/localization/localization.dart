import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

extension AppLocalizationContextX on BuildContext {
  /// Access translations via: `context.string('key')`.
  String string(String key) => AppLocalizations.of(this)._string(key);
}

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = [Locale('en'), Locale('ar')];

  static const localizationsDelegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    _AppLocalizationsDelegate(),
  ];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Warshasy',
      'chooseCity': 'Choose city',
      'welcome': 'Welcome',
      'welcomeGreeting': 'Welcome! 👋',
      'homeServicePrompt': 'What service do you need?',
      'homePostService': 'Post a service',
      'homeLoginCta': 'Sign in',
      'searchHint': 'Search for a service...',
      'homeSectionTitle': 'Choose your service',
      'categoryCraftsTitle': 'Crafts',
      'categoryCraftsDesc': 'Electrical & plumbing, carpentry, metalwork, more',
      'categoryTechnicalTitle': 'Technical services',
      'categoryTechnicalDesc': 'Electronics, solar, networks',
      'categoryCleaningTitle': 'Cleaning & home services',
      'categoryCleaningDesc': 'Home/roof cleaning, upholstery, moving, more',
      'openingCategory': 'Opening services for',
      'navHome': 'Home',
      'navChats': 'Chats',
      'navProfile': 'Account',
      'requestService': 'Request service',
      'postService': 'Post service',
      'serviceDetails': 'Service details',
      'chatsList': 'Chats list',
      'chat': 'Chat',
      'login': 'Log in',
      'pageNotFound': 'Page not found',
      'pageNotFoundWithUri': 'Page not found:',
      'loading': 'Loading...',
      'error': 'Error',
      'unexpectedError': 'An unexpected error occurred',
      'tryAgain': 'Try Again',
      'ok': 'OK',
      'servicesAvailable': 'Services Available',
      'searchIn': 'Search in',
      'notSureService': 'Not sure which service?',
      'expertsCanHelp': 'Our experts can help you choose',
      'allServices': 'All Services',
      'searchResults': 'Search Results',
      'noServicesFound': 'No services found',
      'popular': 'Popular',
      'openingItem': 'Opening',
    },
    'ar': {
      'appTitle': 'ورشتي',
      'chooseCity': 'اختر المدينة',
      'welcome': 'مرحباً',
      'welcomeGreeting': 'أهلا وسهلا ! 👋',
      'homeServicePrompt': 'ما هي الخدمة التي تحتاجها',
      'homePostService': 'اعرض خدمة',
      'homeLoginCta': 'أعلن عن نفسك',
      'searchHint': 'ابحث عن خدمة...',
      'homeSectionTitle': 'اختر خدمتك',
      'categoryCraftsTitle': 'الحرف اليدوية',
      'categoryCraftsDesc': 'تمديد كهرباء وصحية، نجارة وحدادة وغيرها',
      'categoryTechnicalTitle': 'الخدمات التقنية',
      'categoryTechnicalDesc': 'الكترونيات، طاقة بديلة وشبكات',
      'categoryCleaningTitle': 'التنظيف والخدمات المنزلية',
      'categoryCleaningDesc': 'تنظيف منازل وأسطح، تنجيد ونقل أثاث وغيرها',
      'openingCategory': 'جاري فتح خدمات',
      'navHome': 'الرئيسية',
      'navChats': 'المحادثات',
      'navProfile': 'الحساب',
      'requestService': 'طلب خدمة',
      'postService': 'نشر خدمة',
      'serviceDetails': 'تفاصيل الخدمة',
      'chatsList': 'قائمة المحادثات',
      'chat': 'محادثة',
      'login': 'تسجيل الدخول',
      'pageNotFound': 'الصفحة غير موجودة',
      'pageNotFoundWithUri': 'الصفحة غير موجودة:',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'unexpectedError': 'حدث خطأ غير متوقع',
      'tryAgain': 'إعادة المحاولة',
      'ok': 'حسناً',
      'servicesAvailable': 'خدمات متاحة',
      'searchIn': 'ابحث في',
      'notSureService': 'لست متأكداً من الخدمة؟',
      'expertsCanHelp': 'خبراؤنا يساعدونك في الاختيار',
      'allServices': 'كل الخدمات',
      'searchResults': 'نتائج البحث',
      'noServicesFound': 'لم يتم العثور على خدمات',
      'popular': 'شائع',
      'openingItem': 'جاري فتح',
      'selectCity': 'اختر المدينة',
    },
  };

  String _string(String key) {
    final languageCode = locale.languageCode;
    return _localizedValues[languageCode]?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }

  String get appTitle => _string('appTitle');
  String get chooseCity => _string('chooseCity');
  String get welcome => _string('welcome');
  String get welcomeGreeting => _string('welcomeGreeting');
  String get homeServicePrompt => _string('homeServicePrompt');
  String get homePostService => _string('homePostService');
  String get homeLoginCta => _string('homeLoginCta');
  String get searchHint => _string('searchHint');
  String get homeSectionTitle => _string('homeSectionTitle');
  String get categoryCraftsTitle => _string('categoryCraftsTitle');
  String get categoryCraftsDesc => _string('categoryCraftsDesc');
  String get categoryTechnicalTitle => _string('categoryTechnicalTitle');
  String get categoryTechnicalDesc => _string('categoryTechnicalDesc');
  String get categoryCleaningTitle => _string('categoryCleaningTitle');
  String get categoryCleaningDesc => _string('categoryCleaningDesc');
  String get openingCategory => _string('openingCategory');
  String get navHome => _string('navHome');
  String get navChats => _string('navChats');
  String get navProfile => _string('navProfile');
  String get requestService => _string('requestService');
  String get login => _string('login');
  String get postService => _string('postService');
  String get serviceDetails => _string('serviceDetails');
  String get chatsList => _string('chatsList');
  String get chat => _string('chat');
  String get pageNotFound => _string('pageNotFound');
  String get pageNotFoundWithUri => _string('pageNotFoundWithUri');
  String get loading => _string('loading');
  String get error => _string('error');
  String get unexpectedError => _string('unexpectedError');
  String get tryAgain => _string('tryAgain');
  String get ok => _string('ok');
  String get servicesAvailable => _string('servicesAvailable');
  String get searchIn => _string('searchIn');
  String get notSureService => _string('notSureService');
  String get expertsCanHelp => _string('expertsCanHelp');
  String get allServices => _string('allServices');
  String get searchResults => _string('searchResults');
  String get noServicesFound => _string('noServicesFound');
  String get popular => _string('popular');
  String get openingItem => _string('openingItem');
  String get selectCity => _string('selectCity');
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .map((l) => l.languageCode)
      .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
