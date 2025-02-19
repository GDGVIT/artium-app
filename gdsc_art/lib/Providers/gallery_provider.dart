import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Model/gallery_model.dart';
import 'package:gdsc_artwork/Repo/gallery.dart';

String baseUrl = BaseUrl.baseUrl;

class GalleryProvider extends ChangeNotifier {
  final GalleryRepo _repo = GalleryRepo();
  int _currentPage = 1;
  final int _limit = 10;
  bool _hasMore = true;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;

  List<GalleryModel> _arts = [];
  bool _hasError = false;
  String? _errorMessage;

  List<GalleryModel> get arts => _arts;
  bool get isInitialLoading => _isInitialLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasError => _hasError;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;

  Future<void> fetchArts({bool refresh = false}) async {
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
      final response = await _repo.gallery({
        'page': refresh ? 1 : _currentPage,
        'limit': _limit,
      });

      if (response['status'] == 'success') {
        final List<GalleryModel> newArts = (response['arts'] as List)
            .map((art) => GalleryModel(
                  id: art['_id'],
                  title: art['title'],
                  likes: art['likes'],
                  imageUrl: baseUrl + art['image'],
                  description: art['description'],
                  artist: ArtistModel(
                    id: art['artist']['_id'],
                    name: art['artist']['name'],
                  ),
                ))
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
}
