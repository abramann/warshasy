// // ============================================
// lib
// ============================================

class PhoneNumber {
  static String format(String number) {
    // Remove spaces and special characters for validation
    final cleanNumber = number.replaceAll(RegExp(r'[\s\-\(\)]'), '').trim();

    if (_isSyrianPhoneNumber(number) && cleanNumber.startsWith('09')) {
      // Convert local Syrian number to international format
      number = '+963${cleanNumber.substring(1)}';
    } else if (_isSyrianPhoneNumber(number) && cleanNumber.startsWith('963')) {
      number = '+$cleanNumber';
    } else {
      number = cleanNumber;
    }

    return number;
  }

  static bool isValidPhoneNumber(String number) {
    return number.length > 16 || number.length < 8 ? false : true;
  }

  static bool _isSyrianPhoneNumber(String number) {
    return number.startsWith('+963') ||
        number.startsWith('963') ||
        (number.startsWith('09') && number.length == 10);
  }
}
