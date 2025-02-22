import 'dart:async';

import 'package:flutter/material.dart';
import 'package:artium/UIComponents/shimmer_gallery_item.dart';

class DynamicAspectRatioImage extends StatefulWidget {
  final String imageUrl;
  final double defaultAspectRatio;
  final bool isGallery;

  const DynamicAspectRatioImage({
    super.key,
    required this.imageUrl,
    required this.isGallery,
    this.defaultAspectRatio = 1.0,
  });

  @override
  State<DynamicAspectRatioImage> createState() =>
      _DynamicAspectRatioImageState();
}

class _DynamicAspectRatioImageState extends State<DynamicAspectRatioImage> {
  double? _aspectRatio;
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  Future<void> _loadImage() async {
    try {
      final image = NetworkImage(widget.imageUrl);
      final completer = Completer<void>();

      image.resolve(const ImageConfiguration()).addListener(
            ImageStreamListener((info, _) {
              if (mounted) {
                setState(() {
                  _aspectRatio = info.image.width / info.image.height;
                  _isLoading = false;
                });
              }
              completer.complete();
            }, onError: (_, __) {
              if (mounted) {
                setState(() {
                  _hasError = true;
                  _isLoading = false;
                });
              }
              completer.complete();
            }),
          );

      await completer.future;
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: (widget.isGallery)
          ? EdgeInsets.only(top: 8, left: 8, right: 8)
          : EdgeInsets.zero,
      child: AspectRatio(
        aspectRatio: _aspectRatio ?? widget.defaultAspectRatio,
        child: _isLoading
            ? ShimmerGalleryItem(aspectRatio: widget.defaultAspectRatio)
            : _hasError
                ? Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
      ),
    );
  }
}
