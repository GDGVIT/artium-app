import 'dart:developer';

import 'package:flutter/material.dart';
import '../Model/theme_model.dart';
import '../Repo/theme.dart';

class ThemeProvider extends ChangeNotifier {
  final ThemeRepo _repo = ThemeRepo();
  ThemeModel? _theme;
  bool _isLoading = false;
  bool _hasError = false;
  String? _errorMessage;

  ThemeModel? get theme => _theme;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String? get errorMessage => _errorMessage;

  Future<void> fetchThemeOfDay() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final response = await _repo.themeOfDay();
      if (response['status'] == 'success') {
        _theme = ThemeModel.fromJson(response['theme']);
        _hasError = false;
        _errorMessage = null;
      } else {
        _hasError = true;
        _errorMessage = response['message'];
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to fetch theme of the day';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<ThemeModel> randomThemes = [];

  Future<void> fetchThemes() async {
    try {
      final response = await _repo.themes();
      if (response['status'] == 'success') {
        final allThemes = (response['themes'] as List)
            .map((theme) => ThemeModel.fromJson(theme))
            .toList();

        allThemes.shuffle();
        randomThemes = allThemes.take(6).toList();
        notifyListeners();
      }
    } catch (e) {
      log(e.toString());
    }
  }
}
