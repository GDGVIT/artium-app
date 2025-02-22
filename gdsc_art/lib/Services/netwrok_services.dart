import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

abstract class BaseApiServices {
  Future<dynamic> postApi(String url, dynamic data);
  Future<dynamic> getApi(String url);
  Future<dynamic> deleteApi(String url, String token); // Add this line
}

class NetworkApiServices extends BaseApiServices {
  // Add timeout duration constant
  static const Duration _timeout = Duration(seconds: 30);

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
      ).timeout(
        _timeout,
        onTimeout: () => throw TimeoutException('Request timed out'),
      );
      responseJson = apiResponse(response);
      log("Response received: $responseJson");
    } on TimeoutException {
      log("Request timed out");
      throw Exception("Request timed out after ${_timeout.inSeconds} seconds");
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
      http.Response response = await http.get(Uri.parse(url)).timeout(
            _timeout,
            onTimeout: () => throw TimeoutException('Request timed out'),
          );
      responseJson = apiResponse(response);
      log("Response received: $responseJson");
    } on TimeoutException {
      log("Request timed out");
      throw Exception("Request timed out after ${_timeout.inSeconds} seconds");
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    return responseJson;
  }

  @override
  Future deleteApi(String url, String token) async {
    dynamic responseJson;

    try {
      log("Sending DELETE request to $url");
      http.Response response = await http.delete(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      ).timeout(
        _timeout,
        onTimeout: () => throw TimeoutException('Request timed out'),
      );
      responseJson = apiResponse(response);
      log("Response received: $responseJson");
    } on TimeoutException {
      log("Request timed out");
      throw Exception("Request timed out after ${_timeout.inSeconds} seconds");
    } catch (e) {
      log(e.toString());
      rethrow;
    }

    return responseJson;
  }
}
