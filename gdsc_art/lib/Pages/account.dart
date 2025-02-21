import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';
import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Constants/common_toast.dart';
import 'package:gdsc_artwork/Model/gallery_model.dart';
import 'package:gdsc_artwork/Providers/create_art_provider.dart';
import 'package:gdsc_artwork/Providers/user_data_provider.dart';
import 'package:gdsc_artwork/UIComponents/gallery_container.dart';
import 'package:gdsc_artwork/UIComponents/shimmer_gallery_item.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  bool _isLoadingMore = false;
  int currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScrollUpdated);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<UserDataProvider>(context, listen: false);
      await provider.getUserData();
      if (provider.userId != null) {
        await provider.fetchArts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _onScrollUpdated() async {
    if (_isLoadingMore) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final provider = Provider.of<UserDataProvider>(context, listen: false);

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
    return Consumer<UserDataProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: CustomColors.primaryBlack,
          body: Column(
            children: [
              const SizedBox(height: 5.0),
              _buildUserDetails(provider),
              const SizedBox(height: 10.0),
              _buildPageIndicators(),
              const SizedBox(height: 10.0),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      currentPageIndex = index;
                    });
                  },
                  children: [
                    _buildArtsSection(provider, false),
                    _buildArtsSection(provider, true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildArtsSection(UserDataProvider provider, bool isPublished) {
    if (provider.isInitialLoading) {
      return _buildShimmerGrid();
    }

    final List<GalleryModel> filteredArts = isPublished
        ? provider.arts.where((art) => art.reviewed == true).toList()
        : provider.arts; // Show all arts in Saved tab

    return RefreshIndicator(
      onRefresh: () => provider.fetchArts(refresh: true),
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
                itemCount: filteredArts.length +
                    (provider.hasMore
                        ? min(provider.remainingItems, provider.limit)
                        : 0),
                itemBuilder: (context, index) {
                  if (index >= filteredArts.length) {
                    return ShimmerGalleryItem(
                      aspectRatio: index.isEven ? 0.8 : 1.2,
                    );
                  }
                  final art = filteredArts[index];
                  return GalleryContainer(
                    imageUrl: BaseUrl.baseUrl! + art.imageUrl,
                    title: art.title,
                    name: art.artist.name,
                    likes: art.likes,
                    aspectRatio: art.aspectRatio ?? 1.0,
                    showReviewStatus: false,
                    isReviewed: art.reviewed!,
                    isAccountPage: true,
                    onDelete: () async {
                      final success = await provider.deleteUserArt(art.slug!);

                      if (success) {
                        commonToast('Art Deleted Succesfully');
                        provider.fetchArts(refresh: true);
                      }
                    },
                    onPublish: !art.reviewed!
                        ? () async {
                            final createArtProvider =
                                Provider.of<CreateArtProvider>(context,
                                    listen: false);
                            final success = await createArtProvider
                                .publishArt(context, artSlug: art.id);
                            if (success) {
                              commonToast('Art submitted for review!');
                              provider.fetchArts(refresh: true);
                            }
                          }
                        : null,
                  );
                },
              ),
            ),
            if (!provider.hasMore && filteredArts.isNotEmpty)
              const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "You've reached the end!",
                  style: TextStyle(color: CustomColors.primaryWhite),
                ),
              ),
            if (filteredArts.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    isPublished ? 'No published arts yet' : 'No saved arts yet',
                    style: const TextStyle(color: CustomColors.primaryCream),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserDetails(UserDataProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: CustomColors.primaryBlack,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: provider.userImage != null
                  ? Image.network(
                      baseUrl! + provider.userImage!,
                      fit: BoxFit.cover,
                      width: 55,
                      height: 55,
                    )
                  : Image.asset(
                      'images/person2.png',
                      fit: BoxFit.cover,
                      width: 55,
                      height: 55,
                    ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.userName ?? 'Guest',
                  style: const TextStyle(
                    color: CustomColors.secondaryCream,
                    fontSize: 19.0,
                    fontFamily: 'OutfitMedium',
                  ),
                ),
                Text(
                  provider.userEmail ?? 'guest@gmail.com',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[600],
                    fontFamily: 'OutfitRegular',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Column(
      children: [
        Row(
          children: [
            _buildTabButton("Saved", 0),
            _buildTabButton("Published", 1),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 2.0,
                color: currentPageIndex == 0
                    ? CustomColors.primaryCream
                    : Colors.transparent,
              ),
            ),
            Expanded(
              child: Container(
                height: 2.0,
                color: currentPageIndex == 1
                    ? CustomColors.primaryCream
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTabButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: currentPageIndex == index
                  ? CustomColors.primaryCream
                  : Colors.grey,
              fontSize: 19.0,
              fontFamily: 'OutfitMedium',
              decoration: currentPageIndex == index
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
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
        itemCount: 6,
        itemBuilder: (context, index) => ShimmerGalleryItem(
          aspectRatio: index.isEven ? 0.8 : 1.2,
        ),
      ),
    );
  }
}
