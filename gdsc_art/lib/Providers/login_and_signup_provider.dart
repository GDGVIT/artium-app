import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Constants/common_toast.dart';
import 'package:gdsc_artwork/Repo/auth.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_notifier.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

String baseUrl = BaseUrl.baseUrl;

class LoginAndSignupProvider with ChangeNotifier {
  final appRepo = AppRepo();
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Future<void> _saveAuthData(String token, User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    await prefs.setString('userId', user.id);
    await prefs.setString('userName', user.name);
    await prefs.setString('userEmail', user.email);
    await prefs.setString('userImage', user.image ?? '');
  }

  Future<void> userLog(dynamic data, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Starting login with data: $data");
      var response = await appRepo.userLogin(data);
      print("Response from login: $response");

      if (response['status'] == 'success') {
        _isLoading = false;
        notifyListeners();

        User user = User.fromJson(response['user']);
        print("Parsed user: $user");
        await _saveAuthData(
          response['token'],
          User.fromJson(response['user']),
        );
        Provider.of<UserNotifier>(context, listen: false).setUser(user);

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _isLoading = false;
        notifyListeners();
        commonToast(response['message']);
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print("Error during login: $error");

      String errorMessage = "Something went wrong";
      try {
        var errorResponse = jsonDecode((error as Exception).toString());
        if (errorResponse.containsKey('message')) {
          errorMessage = errorResponse['message'];
        }
      } catch (e) {
        print("Error parsing error response: $e");

        final RegExp regExp = RegExp(r'"message":"([^"]+)"');
        final match = regExp.firstMatch(error.toString());
        if (match != null) {
          errorMessage = match.group(1) ?? errorMessage;
        }
      }
      commonToast(errorMessage);
    }
  }

  Future<bool> userSignUp(dynamic data, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      print("Starting signup with data: $data");
      var response = await appRepo.userSignup(data);
      print("Response from signup: $response");

      if (response['status'] == 'success') {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        commonToast(response['message']);
        return false;
      }
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      print("Error during signup: $error");

      String errorMessage = "Something went wrong";
      try {
        var errorResponse = jsonDecode(error.toString());
        if (errorResponse.containsKey('message')) {
          errorMessage = errorResponse['message'];
        }
      } catch (e) {
        print("Error parsing error response: $e");

        final RegExp regExp = RegExp(r'"message":"([^"]+)"');
        final match = regExp.firstMatch(error.toString());
        if (match != null) {
          errorMessage = match.group(1) ?? errorMessage;
        }
      }
      commonToast(errorMessage);
      return false; // Indicate failure
    }
  }

  bool isLoadingOtp = false;
  Future<bool> verifyOtp(String email, String otp, BuildContext context) async {
    isLoadingOtp = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/auth/verify?email=$email&otp=$otp'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == 'success') {
          commonToast(responseData['message']);
          isLoadingOtp = false;
          notifyListeners();

          Navigator.pushReplacementNamed(context, '/auth');
          return true;
        } else {
          throw Exception(responseData['message'] ?? 'Failed to verify OTP');
        }
      } else {
        throw Exception('Failed to verify OTP');
      }
    } catch (e) {
      commonToast('Error during OTP verification: $e');
      isLoadingOtp = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> requestOtp(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('$baseUrl/auth/reset-password?email=$email');
      final response = await http.get(
        url,
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          commonToast('OTP sent successfully');
          return true;
        } else {
          commonToast(responseBody['message']);
        }
      } else {
        commonToast('Failed to send OTP');
      }
    } catch (e) {
      commonToast('An error occurred. Please try again.');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> resetPassword(
      Map<String, dynamic> data, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final url = Uri.parse('$baseUrl/auth/set-forgotten-password');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        if (responseBody['success'] == true) {
          commonToast('Password reset successfully');
          Navigator.pushNamed(context, '/home');
        } else {
          commonToast(responseBody['message']);
        }
      } else {
        commonToast('Failed to reset password');
      }
    } catch (e) {
      commonToast('An error occurred. Please try again.');
    }

    _isLoading = false;
    notifyListeners();
  }
}
