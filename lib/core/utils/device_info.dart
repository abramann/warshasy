import 'package:flutter_udid/flutter_udid.dart';

class DeviceInfo {
  static Future<String> getID() async {
    return await FlutterUdid.consistentUdid;
  }
}
