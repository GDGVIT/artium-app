import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Services/netwrok_services.dart';

class AppRepo {
  final BaseApiServices _apiServices = NetworkApiServices();
  String baseURL = BaseUrl.baseUrl;
  Future<dynamic> userLogin(dynamic data) async {
    var reponse = await _apiServices.postApi("$baseURL/auth/login", data);
    try {
      return reponse;
    } catch (e) {
      print(e.toString());
    }
  }

  Future<dynamic> userSignup(dynamic data) async {
    var reponse = await _apiServices.postApi("$baseURL/auth/register", data);
    try {
      return reponse;
    } catch (e) {
      print(e.toString());
    }
  }
}
