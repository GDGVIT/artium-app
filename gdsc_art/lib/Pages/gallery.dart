import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gdsc_artwork/Constants/colors.dart';
import 'package:gdsc_artwork/Providers/gallery_provider.dart';
import 'package:gdsc_artwork/UIComponents/gallery_container.dart';
import 'package:gdsc_artwork/UIComponents/shimmer_gallery_item.dart';
import 'package:provider/provider.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollUpdated);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GalleryProvider>(context, listen: false).fetchArts();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onScrollUpdated() async {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final provider = Provider.of<GalleryProvider>(context, listen: false);

    if (currentScroll >= maxScroll * 0.9 &&
        provider.hasMore &&
        !provider.isLoadingMore) {
      setState(() {
        _isLoadingMore = true;
      });

      await provider.loadNextPage();

      setState(() {
        _isLoadingMore = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBlack,
      body: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<GalleryProvider>(context, listen: false)
              .refreshGallery();
        },
        child: Consumer<GalleryProvider>(
          builder: (context, provider, _) {
            if (provider.isInitialLoading) {
              return _buildShimmerGrid();
            }

            return SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      itemCount: provider.arts.length +
                          (provider.hasMore
                              ? min(provider.remainingItems, provider.limit)
                              : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.arts.length) {
                          final isEven = index.isEven;
                          final randomAspectRatio = isEven
                              ? (0.8 + (index % 3) * 0.1)
                              : (1.2 + (index % 3) * 0.1);

                          return ShimmerGalleryItem(
                            aspectRatio: randomAspectRatio,
                          );
                        }
                        final art = provider.arts[index];
                        return GalleryContainer(
                          imageUrl: art.imageUrl,
                          title: art.title,
                          name: art.artist.name,
                          likes: art.likes,
                          aspectRatio: art.aspectRatio ?? 1.0,
                        );
                      },
                    ),
                  ),
                  if (!provider.hasMore && provider.arts.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "You've reached the end!",
                        style: TextStyle(color: CustomColors.primaryWhite),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, index) => ShimmerGalleryItem(
          aspectRatio: index.isEven
              ? 0.8 + (index % 3) * 0.1 + (index % 3) * 0.1
              : 1.2 + (index % 3) * 0.1 + (index % 3) * 0.1,
        ),
      ),
    );
  }
}