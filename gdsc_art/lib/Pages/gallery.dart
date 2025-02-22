import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:artium/Constants/colors.dart';
import 'package:artium/Providers/gallery_provider.dart';
import 'package:artium/UIComponents/gallery_container.dart';
import 'package:artium/UIComponents/shimmer_gallery_item.dart';
import 'package:provider/provider.dart';

class Gallery extends StatefulWidget {
  const Gallery({super.key});

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  final List<String> _loadingTexts = [
    'Loading gallery...',
    'Fetching artwork...',
    'Almost there...',
    'Preparing your feed...',
  ];
  int _currentLoadingTextIndex = 0;
  Timer? _loadingTimer;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollUpdated);
    _startLoadingAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GalleryProvider>(context, listen: false).fetchArts();
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
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

  void _startLoadingAnimation() {
    _loadingTimer?.cancel();
    _loadingTimer = Timer.periodic(const Duration(milliseconds: 800), (timer) {
      if (mounted) {
        setState(() {
          _currentLoadingTextIndex =
              (_currentLoadingTextIndex + 1) % _loadingTexts.length;
        });
      }
    });
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            color: CustomColors.primaryCream,
          ),
          const SizedBox(height: 24),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Text(
              _loadingTexts[_currentLoadingTextIndex],
              key: ValueKey<int>(_currentLoadingTextIndex),
              style: const TextStyle(
                color: CustomColors.primaryCream,
                fontSize: 16,
                fontFamily: 'OutfitRegular',
              ),
            ),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.0, 0.5),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.error_outline_rounded,
            color: CustomColors.primaryCream,
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            Provider.of<GalleryProvider>(context, listen: false).errorMessage ??
                'Something went wrong',
            style: const TextStyle(
              color: CustomColors.primaryCream,
              fontSize: 16,
              fontFamily: 'OutfitRegular',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              Provider.of<GalleryProvider>(context, listen: false)
                  .refreshGallery();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryCream,
              foregroundColor: CustomColors.primaryBlack,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Try Again',
              style: TextStyle(
                fontFamily: 'OutfitMedium',
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF0D0C0D),
            Color(0xFF1A181A),
          ],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: const Alignment(1, -0.9),
              child: Image.asset('images/general_right.png'),
            ),
            Align(
              alignment: const Alignment(-1, .91),
              child: Image.asset('images/general_left.png'),
            ),
            Consumer<GalleryProvider>(
              builder: (context, provider, _) {
                if (provider.isInitialLoading) {
                  return _buildLoadingIndicator();
                }

                if (provider.hasError) {
                  return _buildErrorState();
                }

                return RefreshIndicator(
                  onRefresh: () => provider.refreshGallery(),
                  child: SingleChildScrollView(
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
                                    ? min(
                                        provider.remainingItems, provider.limit)
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
                              style:
                                  TextStyle(color: CustomColors.primaryWhite),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  // Widget _buildShimmerGrid() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16.0),
  //     child: MasonryGridView.count(
  //       crossAxisCount: 2,
  //       mainAxisSpacing: 10,
  //       crossAxisSpacing: 10,
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemCount: 10,
  //       itemBuilder: (context, index) => ShimmerGalleryItem(
  //         aspectRatio: index.isEven
  //             ? 0.8 + (index % 3) * 0.1 + (index % 3) * 0.1
  //             : 1.2 + (index % 3) * 0.1 + (index % 3) * 0.1,
  //       ),
  //     ),
  //   );
  // }
}
