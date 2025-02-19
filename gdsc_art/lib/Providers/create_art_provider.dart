import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Repo/create_art.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';

class CreateArtProvider with ChangeNotifier {
  final CreateArtRepo _repo = CreateArtRepo();
  bool _isLoading = false;
  String? _error;
  String? _stylizedImage;
  String? _artSlug;
  final TextEditingController themeController = TextEditingController();

  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get stylizedImage => _stylizedImage;

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> checkAuth(BuildContext context) async {
    final token = await _getToken();
    if (token == null) {
      Navigator.pushReplacementNamed(context, '/auth');
      return false;
    }
    return true;
  }

  Future<String> imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  Future<dynamic> stylizeImage({
    required String contentImage,
    required String styleImage,
    required BuildContext context,
  }) async {
    if (!await checkAuth(context)) return false;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final token = await _getToken();
      final response = await _repo.stylizeImage(
        token: token!,
        contentImage: contentImage,
        styleImage: styleImage,
      );

      _stylizedImage = response['image'];
      notifyListeners();
      return _stylizedImage;
    } catch (e) {
      _error = e.toString();
      print(_error);
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveArt({
    String? theme,
    required String title,
    required String description,
    required BuildContext context,
  }) async {
    if (!await checkAuth(context)) return false;
    if (_stylizedImage == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      final token = await _getToken();
      final response = await _repo.saveArt(
        token: token!,
        theme: theme ?? themeController.text,
        image: _stylizedImage!,
        title: title,
        description: description,
      );

      if (response['status'] == 'success') {
        _artSlug = response['art']['slug'];
        return true;
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> publishArt(BuildContext context) async {
    if (!await checkAuth(context)) return false;
    if (_artSlug == null) return false;

    try {
      _isLoading = true;
      notifyListeners();

      final token = await _getToken();
      await _repo.publishArt(
        token: token!,
        artSlug: _artSlug!,
      );

      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void reset() {
    _isLoading = false;
    _error = null;
    _stylizedImage = null;
    _artSlug = null;
    notifyListeners();
  }

  @override
  void dispose() {
    themeController.dispose();
    super.dispose();
  }
}
