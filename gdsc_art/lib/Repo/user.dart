import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Services/netwrok_services.dart';

class UserRepo {
  final BaseApiServices _apiServices = NetworkApiServices();
  String? baseURL = BaseUrl.baseUrl;
  Future<dynamic> getAllUserArts(
    String id,
    Map<String, dynamic>? params,
  ) async {
    try {
      String url = "$baseURL/art/user/$id";
      if (params != null && params.isNotEmpty) {
        final queryString =
            params.entries.map((e) => '${e.key}=${e.value}').join('&');
        url = "$url?$queryString";
      }
      final response = await _apiServices.getApi(url);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch user arts: ${e.toString()}');
    }
  }

  Future<dynamic> deleteArt(String artSlug, String token) async {
    try {
      String url = "$baseURL/art/$artSlug";
      final response = await _apiServices.deleteApi(url, token);
      return response;
    } catch (e) {
      throw Exception('Failed to delete art: ${e.toString()}');
    }
  }
}
