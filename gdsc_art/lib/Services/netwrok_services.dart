import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

abstract class BaseApiServices {
  Future<dynamic> postApi(String url, dynamic data);
  Future<dynamic> getApi(String url);
}

class NetworkApiServices extends BaseApiServices {
  dynamic apiResponse(http.Response response) {
    dynamic responseJson;
    try {
      responseJson = jsonDecode(response.body);
    } catch (e) {
      throw Exception("Failed to decode response");
    }

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 400:
      case 401:
      case 403:
      case 404:
      case 500:
        log("${response.statusCode} Error: ${response.body}");
        throw Exception(response.body);
      default:
        log("Unhandled Status Code (${response.statusCode}): ${response.body}");
        throw Exception(
            "Unhandled Status Code (${response.statusCode}): ${response.body}");
    }
  }

  @override
  Future postApi(String url, dynamic data) async {
    dynamic responseJson;

    try {
      log("Sending POST request to $url with data $data");
      http.Response response = await http.post(
        Uri.parse(url),
        body: jsonEncode(data),
        headers: {"Content-Type": "application/json"},
      );
      responseJson = apiResponse(response);
      log("Response received: $responseJson");
    } catch (e) {
      log(e.toString());
      rethrow;
    }
    return responseJson;
  }

  @override
  Future getApi(String url) async {
    dynamic responseJson;

    try {
      log("Sending GET request to $url");
      http.Response response = await http.get(Uri.parse(url));
      responseJson = apiResponse(response);
      log("Response received: $responseJson");
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    return responseJson;
  }
}
