import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Model/gallery_model.dart';
import 'package:gdsc_artwork/Repo/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? baseUrl = BaseUrl.baseUrl;

class UserDataProvider extends ChangeNotifier {
  String? token;
  String? userId;
  String? userName;
  String? userEmail;
  String? userImage;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  bool _hasError = false;
  bool _hasMore = true;
  String? _errorMessage;
  final UserRepo repo = UserRepo();
  int _currentPage = 1;
  final int _limit = 10;
  List<GalleryModel> _arts = [];
  int _totalCount = 0;
  bool _isLoading = false;

  List<GalleryModel> get arts => _arts;
  bool get isInitialLoading => _isInitialLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  int get limit => _limit;
  int get totalCount => _totalCount;
  int get remainingItems => _totalCount - _arts.length;
  bool get isLoading => _isLoading;

  Future<void> getUserData() async {
    _isLoading = true;
    _hasError = false;
    _errorMessage = null;
    notifyListeners();

    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      token = prefs.getString('token');
      userId = prefs.getString('userId');
      userName = prefs.getString('userName');
      userEmail = prefs.getString('userEmail');
      userImage = prefs.getString('userImage');

      _hasError = false;
      _errorMessage = null;
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to load user data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchArts({bool refresh = false}) async {
    if (userId == null) {
      _hasError = true;
      _errorMessage = 'User ID not found';
      notifyListeners();
      return;
    }

    if (refresh) {
      _currentPage = 1;
      _arts = [];
      _hasMore = true;
      _hasError = false;
      _errorMessage = null;
      _isInitialLoading = true;
      notifyListeners();
    }

    if (!_hasMore || (_isLoadingMore && !refresh)) return;

    _isLoadingMore = true;
    notifyListeners();

    try {
      final response = await repo.getAllUserArts(
        userId!,
        {
          'page': refresh ? 1 : _currentPage,
          'limit': _limit,
        },
      );

      if (response['status'] == 'success') {
        _totalCount = response['count'];

        final List<GalleryModel> newArts = (response['arts'] as List)
            .map((art) => GalleryModel.fromJson(art))
            .toList();

        if (refresh) {
          _arts = newArts;
        } else {
          _arts.addAll(newArts);
        }

        _hasMore = newArts.length >= _limit;
        _currentPage++;
        _hasError = false;
        _errorMessage = null;
      } else {
        _hasError = true;
        _errorMessage = response['message'];
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Failed to fetch arts';
      log('Error fetching arts: $e');
    } finally {
      _isInitialLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  Future<void> loadNextPage() async {
    if (!_hasMore || _isLoadingMore) return;
    await fetchArts();
  }

  Future<void> refreshGallery() async {
    await fetchArts(refresh: true);
  }

  Future<bool> deleteUserArt(String artslug) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await repo.deleteArt(artslug, token!);
      if (response['status'] == 'success') {
        return true;
      }
    } catch (e) {
      log(e.toString());
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    return false;
  }
}
