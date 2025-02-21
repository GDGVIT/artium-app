import 'dart:convert';
import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:http/http.dart' as http;

class CreateArtRepo {
  static String? baseUrl = BaseUrl.baseUrl;

  Future<Map<String, dynamic>> stylizeImage({
    required String token,
    required String contentImage,
    required String styleImage,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/art/model'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'content_image': contentImage,
          'style_image': styleImage,
        }),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return {'error': e.toString()};
    }
    return {'error': 'Unexpected error occurred'};
  }

  Future<Map<String, dynamic>> saveArt({
    required String token,
    required String theme,
    required String image,
    required String title,
    required String description,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/art/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'theme': theme,
          'image': image,
          'title': title,
          'description': description,
        }),
      );
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return {'error': e.toString()};
    }
    return {'error': 'Unexpected error occurred'};
  }

  Future<Map<String, dynamic>> publishArt({
    required String token,
    required String artSlug,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/art/publish/$artSlug'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      return {'error': e.toString()};
    }
    return {'error': 'Unexpected error occurred'};
  }
}
