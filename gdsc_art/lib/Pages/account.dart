import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:artium/Constants/Colors.dart';
import 'package:artium/Constants/base_url.dart';
import 'package:artium/Constants/common_toast.dart';
import 'package:artium/Model/gallery_model.dart';
import 'package:artium/Providers/create_art_provider.dart';
import 'package:artium/Providers/user_data_provider.dart';
import 'package:artium/UIComponents/gallery_container.dart';
import 'package:artium/UIComponents/shimmer_gallery_item.dart';
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
  int? selectedIndex;
  bool isPressed = false;

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

  Widget _buildIOSBackButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
          color: CustomColors.primaryCream,
          width: 2.0,
        ),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: CustomColors.primaryCream,
          size: 20,
        ),
        onPressed: _onRelease,
        splashColor: Colors.transparent,
      ),
    );
  }

  void _onPress(int index) {
    setState(() {
      isPressed = true;
      selectedIndex = index;
    });
  }

  void _onRelease() {
    setState(() {
      isPressed = false;
      selectedIndex = null;
    });
  }

  Widget _buildExpandedContainer(BuildContext context, GalleryModel art) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      decoration: BoxDecoration(
        color: CustomColors.tertiaryBlack,
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 1.0,
                  child: Image.network(
                    BaseUrl.baseUrl! + art.imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                if (art.reviewed!)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: CustomColors.primaryCream,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Published',
                        style: TextStyle(
                          color: CustomColors.primaryBlack,
                          fontSize: 12,
                          fontFamily: 'OutfitMedium',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          art.title,
                          style: const TextStyle(
                            color: CustomColors.primaryCream,
                            fontFamily: "OutfitBold",
                            fontSize: 18,
                          ),
                        ),
                      ),
                      PopupMenuButton<String>(
                        color: const Color(0xFF5B5B5B),
                        icon: const Icon(
                          Icons.more_vert,
                          color: CustomColors.primaryCream,
                          size: 24,
                        ),
                        onSelected: (value) {
                          if (value == 'publish' && !art.reviewed!) {
                            final createArtProvider =
                                Provider.of<CreateArtProvider>(context,
                                    listen: false);
                            createArtProvider
                                .publishArt(context, artSlug: art.id)
                                .then((success) {
                              if (success) {
                                commonToast('Art submitted for review!');
                                Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .fetchArts(refresh: true);
                                _onRelease();
                              }
                            });
                          } else if (value == 'delete') {
                            Provider.of<UserDataProvider>(context,
                                    listen: false)
                                .deleteUserArt(art.slug!)
                                .then((success) {
                              if (success) {
                                commonToast('Art Deleted Successfully');
                                Provider.of<UserDataProvider>(context,
                                        listen: false)
                                    .fetchArts(refresh: true);
                                _onRelease();
                              }
                            });
                          }
                        },
                        itemBuilder: (BuildContext context) => [
                          if (!art.reviewed!)
                            PopupMenuItem<String>(
                              value: 'publish',
                              child: Row(
                                children: [
                                  Image.asset(
                                    'images/popmenuIcon.png',
                                    width: 20,
                                    height: 20,
                                    color: CustomColors.primaryCream,
                                  ),
                                  const SizedBox(width: 8.0),
                                  const Text(
                                    'Publish',
                                    style: TextStyle(
                                        color: CustomColors.primaryCream),
                                  ),
                                ],
                              ),
                            ),
                          PopupMenuItem<String>(
                            value: 'delete',
                            child: Row(
                              children: [
                                Image.asset(
                                  'images/popmenuIcon2.png',
                                  width: 20,
                                  height: 20,
                                  color: CustomColors.primaryCream,
                                ),
                                const SizedBox(width: 8.0),
                                const Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: CustomColors.primaryCream),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: CustomColors.primaryWhite,
                        child: Text(
                          art.artist.name[0].toUpperCase(),
                          style: const TextStyle(
                            color: CustomColors.primaryBlack,
                            fontFamily: "OutfitBold",
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        art.artist.name,
                        style: const TextStyle(
                          color: CustomColors.primaryWhite,
                          fontFamily: "OutfitMedium",
                          fontSize: 16,
                        ),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, provider, _) {
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
              children: [
                Column(
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
                if (isPressed)
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: 0.7,
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                if (selectedIndex != null)
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0,
                    left: MediaQuery.of(context).size.width * 0,
                    child: _buildIOSBackButton(),
                  ),
                if (selectedIndex != null)
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    top: isPressed
                        ? MediaQuery.of(context).size.height * 0.1
                        : 0,
                    left: isPressed
                        ? MediaQuery.of(context).size.width * 0.05
                        : 0,
                    right: isPressed
                        ? MediaQuery.of(context).size.width * 0.05
                        : 0,
                    child: _buildExpandedContainer(
                      context,
                      provider.arts[selectedIndex!],
                    ),
                  ),
              ],
            ),
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
        : provider.arts;

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
                  return GestureDetector(
                    onTap: () => _onPress(index),
                    child: GalleryContainer(
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
                    ),
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
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24),
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
                    color: CustomColors.primaryCream,
                    fontSize: 19.0,
                    fontFamily: 'OutfitMedium',
                  ),
                ),
                Text(
                  provider.userEmail ?? 'guest@gmail.com',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: CustomColors.primaryCream.withOpacity(.5),
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
