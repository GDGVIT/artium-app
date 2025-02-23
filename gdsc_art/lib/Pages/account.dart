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
import 'dart:async';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  bool _isLoadingMore = false;
  int currentPageIndex = 0;
  int? selectedIndex;
  bool isPressed = false;

  final List<String> _loadingTexts = [
    'Loading your profile...',
    'Fetching your art...',
    'Almost there...',
    'Preparing your gallery...',
  ];
  int _currentLoadingTextIndex = 0;
  Timer? _loadingTimer;

  late AnimationController _expandController;
  late Animation<double> _rotationAnimation;

  late AnimationController _backgroundController;
  late Animation<double> _backgroundOpacity;
  late AnimationController _backButtonController;
  late Animation<double> _backButtonOpacity;
  late Animation<double> _backButtonSlide;

  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Size _originalSize = Size.zero;
  late Rect _originalRect = Rect.zero;

  final Map<int, GlobalKey> _savedItemKeys = {};
  final Map<int, GlobalKey> _publishedItemKeys = {};

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController.addListener(_onScrollUpdated);
    _startLoadingAnimation();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 0.03,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOutCubic),
    ));
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _backgroundOpacity = Tween<double>(
      begin: 0.0,
      end: 0.85,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeOut,
    ));

    _backButtonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _backButtonOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backButtonController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    ));

    _backButtonSlide = Tween<double>(
      begin: -20.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _backButtonController,
      curve: const Interval(0.2, 1.0, curve: Curves.easeOut),
    ));

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<UserDataProvider>(context, listen: false);
      await provider.getUserData(context);
      if (provider.userId != null) {
        await provider.fetchArts();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loadingTimer?.cancel();
    _scrollController.dispose();
    _pageController.dispose();
    _expandController.dispose();
    _backgroundController.dispose();
    _backButtonController.dispose();
    _fadeController.dispose();
    _savedItemKeys.clear();
    _publishedItemKeys.clear();
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

  Widget _buildErrorState(UserDataProvider provider) {
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
            provider.errorMessage ?? 'Something went wrong',
            style: const TextStyle(
              color: CustomColors.primaryCream,
              fontSize: 16,
              fontFamily: 'OutfitRegular',
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => provider.refreshGallery(),
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

  Widget _buildIOSBackButton() {
    return AnimatedBuilder(
      animation: _backButtonController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_backButtonSlide.value, 0),
          child: Opacity(
            opacity: _backButtonOpacity.value,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(
                  color: CustomColors.primaryWhite
                      .withValues(alpha: _backButtonOpacity.value),
                  width: 2.0,
                ),
              ),
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: CustomColors.primaryWhite,
                  size: 24,
                ),
                onPressed: _onRelease,
                splashColor: Colors.transparent,
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPress(int index, BuildContext context, RenderBox box) {
    final RenderBox itemRenderBox = box;
    _originalSize = itemRenderBox.size;
    final position = itemRenderBox.localToGlobal(Offset.zero);
    _originalRect = position & _originalSize;

    final screenSize = MediaQuery.of(context).size;
    final targetWidth = screenSize.width * 0.9;
    final scale = targetWidth / _originalSize.width;

    final targetTop = screenSize.height * 0.15;

    final currentCenterX = position.dx + (_originalSize.width / 2);
    final targetCenterX = screenSize.width / 2;
    final horizontalOffset =
        (targetCenterX - currentCenterX) / _originalSize.width;

    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(
        horizontalOffset,
        (targetTop - position.dy) / _originalSize.height,
      ),
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
    ));

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: scale,
    ).animate(CurvedAnimation(
      parent: _expandController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOutCubic),
    ));

    setState(() {
      isPressed = true;
      selectedIndex = index;
    });
    _expandController.forward();
    _backgroundController.forward();
    _backButtonController.forward();
    _fadeController.forward();
  }

  void _onRelease() {
    _fadeController.reverse();
    _backgroundController.reverse();
    _backButtonController.reverse();
    _expandController.reverse().then((_) {
      setState(() {
        isPressed = false;
        selectedIndex = null;
      });
    });
  }

  Widget _buildExpandedContainer(BuildContext context, GalleryModel art) {
    return Container(
      margin: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: Color(0xff363336),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 16.0, left: 16, right: 16),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        BaseUrl.baseUrl! + art.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
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
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 0.0,
                bottom: 8,
              ),
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
                          color: CustomColors.primaryWhite,
                          size: 24,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
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
                                if (!context.mounted) return;
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
                                if (!context.mounted) return;
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
                                      color: CustomColors.primaryCream,
                                      fontFamily: 'OutfitSemiBold',
                                    ),
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
                                      color: CustomColors.primaryCream,
                                      fontFamily: 'OutfitSemiBold'),
                                ),
                              ],
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

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, provider, _) {
        return Container(
          decoration: const BoxDecoration(color: Color(0xff0D0B0A)),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: [
                Column(
                  children: [
                    const SizedBox(height: 5.0),
                    _buildUserDetails(provider),
                    const SizedBox(height: 10.0),
                    TabBar(
                      controller: _tabController,
                      indicatorColor: CustomColors.primaryCream,
                      labelColor: CustomColors.primaryCream,
                      unselectedLabelColor: Colors.white,
                      labelStyle: const TextStyle(
                        fontSize: 19.0,
                        fontFamily: 'OutfitMedium',
                      ),
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 3,
                      dividerColor: Colors.transparent,
                      tabs: const [
                        Tab(text: 'Saved'),
                        Tab(text: 'Published'),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _buildArtsSection(provider, false),
                          _buildArtsSection(provider, true),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isPressed)
                  AnimatedBuilder(
                    animation: _backgroundController,
                    builder: (context, child) {
                      return Positioned.fill(
                        child: GestureDetector(
                          onTap: _onRelease,
                          child: Container(
                            color: Colors.black
                                .withValues(alpha: _backgroundOpacity.value),
                          ),
                        ),
                      );
                    },
                  ),
                if (selectedIndex != null)
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.025,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: _buildIOSBackButton(),
                  ),
                if (selectedIndex != null)
                  Positioned.fill(
                    child: Stack(
                      children: [
                        AnimatedBuilder(
                          animation: _expandController,
                          builder: (context, child) {
                            final screenSize = MediaQuery.of(context).size;
                            final width =
                                _originalRect.width * _scaleAnimation.value;
                            final scaledOffset = _slideAnimation.value;

                            final targetCenterX =
                                (screenSize.width - width) / 2;

                            return Positioned(
                              left: targetCenterX,
                              top: _originalRect.top +
                                  (_originalRect.height * scaledOffset.dy),
                              width: width,
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Transform(
                                  transform: Matrix4.identity()
                                    ..setEntry(3, 2, 0.001)
                                    ..rotateX(_rotationAnimation.value),
                                  alignment: Alignment.topCenter,
                                  child: _buildExpandedContainer(
                                    context,
                                    provider.arts[selectedIndex!],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
      return _buildLoadingIndicator();
    }

    if (provider.hasError) {
      return _buildErrorState(provider);
    }

    final List<GalleryModel> filteredArts = isPublished
        ? provider.arts.where((art) => art.reviewed == true).toList()
        : provider.arts;

    return RefreshIndicator(
      onRefresh: () => provider.refreshGallery(),
      child: filteredArts.isEmpty
          ? ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          isPublished
                              ? 'No published arts yet'
                              : 'No saved arts yet',
                          style: const TextStyle(
                            color: CustomColors.primaryCream,
                            fontSize: 16,
                            fontFamily: 'OutfitRegular',
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () => provider.refreshGallery(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: CustomColors.primaryCream,
                            foregroundColor: CustomColors.primaryBlack,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Refresh',
                            style: TextStyle(
                              fontFamily: 'OutfitMedium',
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )
          : ListView(
              controller: _scrollController,
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
                        final isEven = index.isEven;
                        final randomAspectRatio = isEven
                            ? (0.8 + (index % 3) * 0.1)
                            : (1.2 + (index % 3) * 0.1);

                        return ShimmerGalleryItem(
                          aspectRatio: randomAspectRatio,
                        );
                      }

                      final art = filteredArts[index];
                      return GestureDetector(
                        key: (isPublished
                            ? (_publishedItemKeys[index] ??= GlobalKey())
                            : (_savedItemKeys[index] ??= GlobalKey())),
                        onTapUp: (details) {
                          final RenderBox box = (isPublished
                                  ? _publishedItemKeys[index]!
                                  : _savedItemKeys[index]!)
                              .currentContext!
                              .findRenderObject() as RenderBox;
                          _onPress(index, context, box);
                        },
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
                            final success =
                                await provider.deleteUserArt(art.slug!);

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
                    child: Center(
                      child: Text(
                        "You've reached the end!",
                        style: TextStyle(color: CustomColors.primaryWhite),
                      ),
                    ),
                  ),
              ],
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
                    color: CustomColors.primaryCream.withValues(alpha: .5),
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
}
