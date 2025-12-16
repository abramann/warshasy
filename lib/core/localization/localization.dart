import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

extension AppLocalizationContextX on BuildContext {
  /// Access translations via: context.string('key').
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
      'welcomeGreeting': 'Welcome!',
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
      'notFindService': 'Can not find your service?',
      'contactUsToAdd': 'Contact us to add',
      'allServices': 'All Services',
      'searchResults': 'Search Results',
      'noServicesFound': 'No services found',
      'popular': 'Popular',
      'openingItem': 'Opening',
      'selectCity': 'Select city',
      'save': 'Save',
      'cancel': 'Cancel',
      'optionalSuffix': '(Optional)',
      'saveChanges': 'Save changes',
      'profileSetupTitle': 'Complete profile',
      'fullNameLabel': 'Full name',
      'fullNameHint': 'Enter your full name',
      'nameRequiredError': 'Please enter your full name',
      'nameTooShortError': 'Name must be at least 3 characters',
      'locationLabel': 'Location',
      'bioLabel': 'Bio',
      'bioHint': 'Write a short bio about you...',
      'profileUpdated': 'Profile updated successfully',
      'takePhoto': 'Take a photo',
      'chooseFromGallery': 'Choose from gallery',
      'deletePhoto': 'Remove photo',
      'avatarUploadError': 'Something went wrong while uploading the photo',
      'startupTagline': 'Fast, reliable home & professional services',
      'loadingDataError': 'Error loading data',
      'verifyPhoneTitle': 'Verify phone number',
      'otpHeader': 'Enter the verification code',
      'otpDescriptionPrefix': 'We sent a verification code via',
      'otpDescriptionTo': 'to',
      'whatsappLabel': 'WhatsApp',
      'otpInvalid': 'Please enter the 4-digit verification code',
      'verificationCodeSent': 'Verification code sent successfully',
      'clearCode': 'Clear code',
      'verifyCodeCta': 'Verify code',
      'didntReceiveCode': "Didn't receive the code?",
      'resendCode': 'Resend code',
      'resendCountdown': 'Resend in {seconds}s',
      'whatsappHelp': 'If you have any issue, we can help you on WhatsApp.',
      'changePhone': 'Change phone number',
      'myProfileTitle': 'My profile',
      'userProfileTitle': 'Profile',
      'editProfile': 'Edit profile',
      'settings': 'Settings',
      'updating': 'Updating...',
      'memberSince': 'Member since',
      'contactInfo': 'Contact info',
      'phoneNumber': 'Phone number',
      'servicesOffered': 'Services offered',
      'servicesPlaceholder': 'Your services will appear here soon.',
      'add': 'Add',
      'messageUser': 'Send message',
      'callUser': 'Call',
      'callingNumber': 'Calling {phone}',
      'days': 'days',
      'months': 'months',
      'years': 'years',
      'serviceDetailsTitle': 'Service details',
      'serviceIdLabel': 'Service ID',
      'chatsListTitle': 'Chats list',
      'chatTitle': 'Chat',
      'signInTitle': 'Welcome!',
      'signInSubtitle':
          'Enter your phone number to receive a verification code',
      'phoneLabel': 'Phone number',
      'phoneRequiredError': 'Please enter your phone number',
      'phoneInvalidError': 'Please enter a valid phone number',
      'helperNote':
          'We will send a verification code to your number and keep it private',
      'signingIn': 'Signing in...',
      'signInCta': 'Continue with phone',
      'loginSuccess': 'Signed in successfully',
      'privacyNote':
          'By continuing, you agree to our Terms of Service and Privacy Policy',
    },
    'ar': {
      'appTitle': 'ورشتي',
      'chooseCity': 'اختر المدينة',
      'welcome': 'مرحباً',
      'welcomeGreeting': 'مرحباً!',
      'homeServicePrompt': 'ما الخدمة التي تحتاجها؟',
      'homePostService': 'أضف خدمة',
      'homeLoginCta': 'تسجيل الدخول',
      'searchHint': 'ابحث عن خدمة...',
      'homeSectionTitle': 'اختر خدمتك',
      'categoryCraftsTitle': 'الحرف',
      'categoryCraftsDesc': 'كهرباء، سباكة، نجارة، حدادة، وغيرها',
      'categoryTechnicalTitle': 'الخدمات التقنية',
      'categoryTechnicalDesc': 'إلكترونيات، طاقة شمسية، شبكات',
      'categoryCleaningTitle': 'التنظيف والخدمات المنزلية',
      'categoryCleaningDesc': 'تنظيف المنازل والأسطح، المفروشات، النقل، وغيرها',
      'openingCategory': 'فتح الخدمات لـ',
      'navHome': 'الرئيسية',
      'navChats': 'المحادثات',
      'navProfile': 'الحساب',
      'requestService': 'طلب خدمة',
      'postService': 'إضافة خدمة',
      'serviceDetails': 'تفاصيل الخدمة',
      'chatsList': 'قائمة المحادثات',
      'chat': 'محادثة',
      'login': 'تسجيل الدخول',
      'pageNotFound': 'الصفحة غير موجودة',
      'pageNotFoundWithUri': 'الصفحة غير موجودة:',
      'loading': 'جاري التحميل...',
      'error': 'خطأ',
      'unexpectedError': 'حدث خطأ غير متوقع',
      'tryAgain': 'أعد المحاولة',
      'ok': 'حسناً',
      'servicesAvailable': 'الخدمات المتاحة',
      'searchIn': 'ابحث في',
      'notFindService': 'لا يمكنك العثور على خدمتك؟',
      'contactUsToAdd': 'تواصل معنا لإضافتها',
      'allServices': 'كل الخدمات',
      'searchResults': 'نتائج البحث',
      'noServicesFound': 'لم يتم العثور على خدمات',
      'popular': 'شائع',
      'openingItem': 'فتح',
      'selectCity': 'اختر المدينة',
      'save': 'حفظ',
      'cancel': 'إلغاء',
      'optionalSuffix': '(اختياري)',
      'saveChanges': 'حفظ التغييرات',
      'profileSetupTitle': 'إعداد الملف الشخصي',
      'fullNameLabel': 'الاسم الكامل',
      'fullNameHint': 'اكتب اسمك الكامل',
      'nameRequiredError': 'الرجاء إدخال الاسم الكامل',
      'nameTooShortError': 'يجب أن يكون الاسم 3 أحرف على الأقل',
      'locationLabel': 'الموقع',
      'bioLabel': 'نبذة',
      'bioHint': 'اكتب نبذة قصيرة عنك...',
      'profileUpdated': 'تم تحديث الملف الشخصي بنجاح',
      'takePhoto': 'التقاط صورة',
      'chooseFromGallery': 'اختيار من المعرض',
      'deletePhoto': 'حذف الصورة',
      'avatarUploadError': 'حدث خطأ أثناء تحميل الصورة',
      'startupTagline': 'حلول سريعة وموثوقة لخدماتك المنزلية والمهنية',
      'loadingDataError': 'حدث خطأ أثناء تحميل البيانات',
      'verifyPhoneTitle': 'تأكيد رقم الهاتف',
      'otpHeader': 'أدخل رمز التحقق المرسل',
      'otpDescriptionPrefix': 'أرسلنا رمز التحقق عبر',
      'otpDescriptionTo': 'إلى الرقم',
      'whatsappLabel': 'واتساب',
      'otpInvalid': 'الرجاء إدخال رمز تحقق مكوّن من 4 أرقام',
      'verificationCodeSent': 'تم إرسال رمز التحقق بنجاح',
      'clearCode': 'مسح الرمز',
      'verifyCodeCta': 'تأكيد الرمز',
      'didntReceiveCode': 'لم يصلك الرمز؟',
      'resendCode': 'إعادة إرسال الرمز',
      'resendCountdown': 'إعادة الإرسال خلال {seconds} ثانية',
      'whatsappHelp': 'إذا واجهت أي مشكلة يمكننا مساعدتك عبر واتساب.',
      'changePhone': 'تغيير رقم الهاتف',
      'myProfileTitle': 'ملفي الشخصي',
      'userProfileTitle': 'الملف الشخصي',
      'editProfile': 'تعديل الملف الشخصي',
      'settings': 'الإعدادات',
      'updating': 'جاري التحديث...',
      'memberSince': 'عضو منذ',
      'contactInfo': 'معلومات التواصل',
      'phoneNumber': 'رقم الهاتف',
      'servicesOffered': 'الخدمات المقدمة',
      'servicesPlaceholder': 'ستظهر خدماتك هنا قريباً.',
      'add': 'إضافة',
      'messageUser': 'إرسال رسالة',
      'callUser': 'اتصال هاتفي',
      'callingNumber': 'جاري الاتصال بـ {phone}',
      'days': 'يوم',
      'months': 'شهر',
      'years': 'سنة',
      'serviceDetailsTitle': 'تفاصيل الخدمة',
      'serviceIdLabel': 'معرف الخدمة',
      'chatsListTitle': 'قائمة المحادثات',
      'chatTitle': 'محادثة',
      'signInTitle': 'أهلاً بك!',
      'signInSubtitle': 'أدخل رقم هاتفك لإرسال رمز التحقق',
      'phoneLabel': 'رقم الهاتف',
      'phoneRequiredError': 'الرجاء إدخال رقم الهاتف',
      'phoneInvalidError': 'الرجاء إدخال رقم هاتف صالح',
      'helperNote': 'سنرسل رمز التحقق إلى رقمك ونحافظ على خصوصيته',
      'signingIn': 'جاري تسجيل الدخول...',
      'signInCta': 'متابعة برقم الهاتف',
      'loginSuccess': 'تم تسجيل الدخول بنجاح',
      'privacyNote': 'بالمتابعة فإنك توافق على شروط الخدمة وسياسة الخصوصية',
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
  String get notFindService => _string('notFindService');
  String get contactUsToAdd => _string('contactUsToAdd');
  String get allServices => _string('allServices');
  String get searchResults => _string('searchResults');
  String get noServicesFound => _string('noServicesFound');
  String get popular => _string('popular');
  String get openingItem => _string('openingItem');
  String get selectCity => _string('selectCity');
  String get save => _string('save');
  String get cancel => _string('cancel');
  String get optionalSuffix => _string('optionalSuffix');
  String get saveChanges => _string('saveChanges');
  String get profileSetupTitle => _string('profileSetupTitle');
  String get fullNameLabel => _string('fullNameLabel');
  String get fullNameHint => _string('fullNameHint');
  String get nameRequiredError => _string('nameRequiredError');
  String get nameTooShortError => _string('nameTooShortError');
  String get locationLabel => _string('locationLabel');
  String get bioLabel => _string('bioLabel');
  String get bioHint => _string('bioHint');
  String get profileUpdated => _string('profileUpdated');
  String get takePhoto => _string('takePhoto');
  String get chooseFromGallery => _string('chooseFromGallery');
  String get deletePhoto => _string('deletePhoto');
  String get avatarUploadError => _string('avatarUploadError');
  String get startupTagline => _string('startupTagline');
  String get loadingDataError => _string('loadingDataError');
  String get verifyPhoneTitle => _string('verifyPhoneTitle');
  String get otpHeader => _string('otpHeader');
  String get otpDescriptionPrefix => _string('otpDescriptionPrefix');
  String get otpDescriptionTo => _string('otpDescriptionTo');
  String get whatsappLabel => _string('whatsappLabel');
  String get otpInvalid => _string('otpInvalid');
  String get verificationCodeSent => _string('verificationCodeSent');
  String get clearCode => _string('clearCode');
  String get verifyCodeCta => _string('verifyCodeCta');
  String get didntReceiveCode => _string('didntReceiveCode');
  String get resendCode => _string('resendCode');
  String resendCountdown(int seconds) =>
      _string('resendCountdown').replaceFirst('{seconds}', '');
  String get whatsappHelp => _string('whatsappHelp');
  String get changePhone => _string('changePhone');
  String get myProfileTitle => _string('myProfileTitle');
  String get userProfileTitle => _string('userProfileTitle');
  String get editProfile => _string('editProfile');
  String get settings => _string('settings');
  String get updating => _string('updating');
  String memberSince(String duration) => ' ';
  String get contactInfo => _string('contactInfo');
  String get phoneNumber => _string('phoneNumber');
  String get servicesOffered => _string('servicesOffered');
  String get servicesPlaceholder => _string('servicesPlaceholder');
  String get add => _string('add');
  String get messageUser => _string('messageUser');
  String get callUser => _string('callUser');
  String callingNumber(String phone) =>
      _string('callingNumber').replaceFirst('{phone}', phone);
  String get days => _string('days');
  String get months => _string('months');
  String get years => _string('years');
  String get serviceDetailsTitle => _string('serviceDetailsTitle');
  String serviceIdLabel(String id) => ': ';
  String get chatsListTitle => _string('chatsListTitle');
  String get chatTitle => _string('chatTitle');
  String get signInTitle => _string('signInTitle');
  String get signInSubtitle => _string('signInSubtitle');
  String get phoneLabel => _string('phoneLabel');
  String get phoneRequiredError => _string('phoneRequiredError');
  String get phoneInvalidError => _string('phoneInvalidError');
  String get helperNote => _string('helperNote');
  String get signingIn => _string('signingIn');
  String get signInCta => _string('signInCta');
  String get loginSuccess => _string('loginSuccess');
  String get privacyNote => _string('privacyNote');
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
