import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:warshasy/core/errors/errors.dart';

class Network {
  Future<bool> checkNetworkStatus() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    } else {
      return true;
    }
  }

  Future<T> guard<T>(Future<T> Function() request) async {
    final networkAccess = await checkNetworkStatus();
    if (!networkAccess) {
      throw ConnectionTimeoutException('No internet connection');
    }

    try {
      return await request().timeout(const Duration(seconds: 25));
    } on TimeoutException {
      throw ConnectionTimeoutException('Connection timed out');
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw ServerException('Unexpected error: ${e.toString()}');
    }
  }
}
