import 'dart:math';
import 'dart:async';

import 'package:artium/Model/gallery_model.dart';
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

class _GalleryState extends State<Gallery> with TickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int? selectedIndex;
  bool isPressed = false;

  final List<String> _loadingTexts = [
    'Loading gallery...',
    'Fetching artwork...',
    'Almost there...',
    'Preparing your feed...',
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

  final Map<int, GlobalKey> _itemKeys = {};

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GalleryProvider>(context, listen: false).fetchArts();
    });
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    _scrollController.dispose();
    _expandController.dispose();
    _backgroundController.dispose();
    _backButtonController.dispose();
    _fadeController.dispose();
    _itemKeys.clear();
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
            color: Colors.black.withValues(alpha: 0.2),
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
                        art.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                top: 12,
                bottom: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    art.title,
                    style: const TextStyle(
                      color: CustomColors.primaryCream,
                      fontFamily: "OutfitBold",
                      fontSize: 18,
                    ),
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

                return Stack(
                  children: [
                    RefreshIndicator(
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
                                        ? min(provider.remainingItems,
                                            provider.limit)
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
                                  return GestureDetector(
                                    key: (_itemKeys[index] ??= GlobalKey()),
                                    onTapUp: (details) {
                                      final RenderBox box = (_itemKeys[index]!)
                                          .currentContext!
                                          .findRenderObject() as RenderBox;
                                      _onPress(index, context, box);
                                    },
                                    child: GalleryContainer(
                                      imageUrl: art.imageUrl,
                                      title: art.title,
                                      name: art.artist.name,
                                      likes: art.likes,
                                      aspectRatio: art.aspectRatio ?? 1.0,
                                    ),
                                  );
                                },
                              ),
                            ),
                            if (!provider.hasMore && provider.arts.isNotEmpty)
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Text(
                                  "You've reached the end!",
                                  style: TextStyle(
                                      color: CustomColors.primaryWhite),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    if (isPressed)
                      AnimatedBuilder(
                        animation: _backgroundController,
                        builder: (context, child) {
                          return Positioned.fill(
                            child: GestureDetector(
                              onTap: _onRelease,
                              child: Container(
                                color: Colors.black.withValues(
                                  alpha: _backgroundOpacity.value,
                                ),
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
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
