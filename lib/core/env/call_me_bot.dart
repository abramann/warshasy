class CallMeBot {
  static const String _callMeBotKey = '6471288';

  static String callMeBotUrl(String phone, String code, String message) =>
      'https://api.callmebot.com/whatsapp.php?phone=' +
      phone +
      '&text=' +
      message.replaceAll(RegExp(r' '), '+') +
      '&apikey=' +
      _callMeBotKey;
}
