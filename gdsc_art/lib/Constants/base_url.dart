import 'dart:io' show Platform;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseUrl {
  static String? get baseUrl {
    final environment = dotenv.env['ENVIRONMENT'] ?? 'debug';

    if (environment == 'prod') {
      return dotenv.env['API_URL_PROD'];
    }

    if (Platform.isAndroid) {
      return dotenv.env['API_URL_DEBUG_ANDROID'] ?? 'http://10.0.2.2:8000';
    } else if (Platform.isIOS) {
      return dotenv.env['API_URL_DEBUG_IOS'] ?? 'http://localhost:8000';
    }

    return 'https://artium.rupaaksrinivas.tech';
  }
}
