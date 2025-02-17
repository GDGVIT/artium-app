import 'package:gdsc_artwork/Services/netwrok_services.dart';

class ThemeRepo {
  final BaseApiServices _apiServices = NetworkApiServices();
  String baseURL = "http://localhost:8000";

  Future<dynamic> themeOfDay() async {
    try {
      return await _apiServices.getApi("$baseURL/theme/theme-of-day");
    } catch (e) {
      rethrow;
    }
  }

  Future<dynamic> themes() async {
    try {
      return await _apiServices.getApi("$baseURL/theme/");
    } catch (e) {
      rethrow;
    }
  }
}
