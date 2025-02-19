import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Services/netwrok_services.dart';

class GalleryRepo {
  final BaseApiServices _apiServices = NetworkApiServices();
  String? baseURL = BaseUrl.baseUrl;
  Future<dynamic> gallery(Map<String, dynamic>? params) async {
    try {
      String url = "$baseURL/art/gallery";
      if (params != null && params.isNotEmpty) {
        final queryString =
            params.entries.map((e) => '${e.key}=${e.value}').join('&');
        url = "$url?$queryString";
      }

      final response = await _apiServices.getApi(url);
      return response;
    } catch (e) {
      throw Exception('Failed to fetch gallery: ${e.toString()}');
    }
  }
}
