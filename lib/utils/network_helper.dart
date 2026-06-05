import 'dart:io';

class NetworkHelper {
  NetworkHelper._();

  static Future<bool> hasConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } on SocketException {
      return false;
    } on Exception {
      return false;
    }
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException([this.message = 'No internet connection']);
}
