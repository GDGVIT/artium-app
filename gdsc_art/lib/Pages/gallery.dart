import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gdsc_artwork/Constants/colors.dart';
import 'package:gdsc_artwork/Providers/gallery_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
                      itemCount:
                          provider.arts.length + (provider.hasMore ? 2 : 0),
                      itemBuilder: (context, index) {
                        if (index >= provider.arts.length) {
                          return const ShimmerGalleryItem();
                        }
                        final art = provider.arts[index];
                        return GalleryContainer(
                          imageUrl: art.imageUrl,
                          title: art.title,
                          name: art.artist.name,
                          likes: art.likes,
                        );
                      },
                    ),
                  ),
                  if (!provider.hasMore && provider.arts.isNotEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No more artworks to load',
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
    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 10,
      itemBuilder: (context, index) => const ShimmerGalleryItem(),
    );
  }
}

class ShimmerGalleryItem extends StatelessWidget {
  const ShimmerGalleryItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[800]!,
      highlightColor: Colors.grey[700]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    topRight: Radius.circular(15.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    height: 10,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 100,
                        height: 10,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GalleryContainer extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String name;
  final int likes;

  const GalleryContainer({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.name,
    required this.likes,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.tertiaryBlack,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const ShimmerGalleryItem();
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[900],
                    child: const Center(
                      child: Icon(
                        Icons.error_outline,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.primaryCream,
                      fontFamily: "OutfitBold",
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10.0,
                        backgroundColor: CustomColors.primaryWhite,
                        child: Text(
                          name[0].toUpperCase(),
                          style: const TextStyle(
                            color: CustomColors.primaryBlack,
                            fontFamily: "OutfitBold",
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: CustomColors.primaryWhite,
                            fontFamily: "OutfitMedium",
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$likes',
                            style: const TextStyle(
                              color: CustomColors.primaryWhite,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
