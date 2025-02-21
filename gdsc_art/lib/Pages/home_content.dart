import 'dart:async';
import 'dart:developer';

import 'package:artium/Constants/common_toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:artium/Constants/base_url.dart';
import 'package:artium/Constants/colors.dart';
import 'package:artium/Pages/select_style_page.dart';
import 'package:artium/UIComponents/side_bar.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:artium/UIComponents/art_style_info_box.dart';
import 'package:provider/provider.dart';
import 'package:artium/Providers/theme_provider.dart';
import 'package:artium/Data/theme_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? baseUrl = BaseUrl.baseUrl;

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  bool isAuth = false;
  int currentImageIndex = 0;
  late Future<void> themesFuture;
  late SharedPreferences prefs;
  bool _isLoading = true;
  final List<String> _loadingTexts = [
    'Connecting to server...',
    'Fetching art styles...',
    'Loading themes...',
    'Almost there...',
    'Checking connection...',
  ];
  int _currentLoadingTextIndex = 0;
  Timer? _loadingTimer;
  Timer? fallbackTimer;
  bool showStatic = false;

  @override
  void initState() {
    super.initState();
    checkAuthStatus();
    _startLoadingAnimation();
    themesFuture = _initializeThemes();
  }

  Future<void> checkAuthStatus() async {
    try {
      prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      setState(() {
        isAuth = token != null;
      });
    } catch (e) {
      log('Error checking auth status: $e');
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

    fallbackTimer = Timer(const Duration(seconds: 5), () {
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
          showStatic = true;
        });
        _loadingTimer?.cancel();
        commonToast("No internet connection. Showing offline content");
      }
    });
  }

  Future<void> _initializeThemes() async {
    try {
      await Provider.of<ThemeProvider>(context, listen: false).fetchThemes();
      if (mounted) {
        setState(() {
          _isLoading = false;
          showStatic = false;
        });
      }
    } catch (e) {
      log('Error loading themes: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          showStatic = true;
        });
      }
    }
  }

  List<Map<String, String>> getThemeData(ThemeProvider provider) {
    if (provider.randomThemes.isEmpty) {
      return StaticThemeData.defaultThemes;
    }

    return provider.randomThemes
        .map((theme) => {
              'image': baseUrl! + theme.themeImages.first,
              'title': theme.title,
              'description': theme.description,
            })
        .toList();
  }

  @override
  void dispose() {
    _loadingTimer?.cancel();
    fallbackTimer?.cancel();
    super.dispose();
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

  Widget _buildHeaderText() {
    return Column(
      children: const [
        Wrap(
          spacing: 0,
          alignment: WrapAlignment.center,
          children: [
            Text(
              'Discover',
              style: TextStyle(
                color: CustomColors.secondaryCream,
                fontSize: 24.0,
                fontFamily: 'OutfitMedium',
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              'art styles.',
              style: TextStyle(
                color: CustomColors.primaryWhite,
                fontSize: 24.0,
                fontFamily: 'OutfitMedium',
              ),
            ),
          ],
        ),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 0,
          children: [
            Text(
              'Stylize',
              style: TextStyle(
                color: CustomColors.primaryBrown,
                fontSize: 24.0,
                fontFamily: 'OutfitMedium',
              ),
            ),
            SizedBox(width: 10.0),
            Text(
              'images.',
              style: TextStyle(
                color: CustomColors.primaryWhite,
                fontSize: 24.0,
                fontFamily: 'OutfitMedium',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Update the _buildImageSliderItem method
  Widget _buildImageSliderItem(Map<String, String> theme, bool isCurrent) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
      opacity: isCurrent ? 1.0 : 0.25,
      child: Container(
        height: 350,
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: theme['image']!.startsWith('http')
                  ? CachedNetworkImage(
                      imageUrl: theme['image']!,
                      fit: BoxFit.cover,
                      height: 180.0,
                      width: double.infinity,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF222122),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: CustomColors.primaryCream,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) {
                        // Show offline fallback image
                        return Container(
                          color: const Color(0xFF222122),
                          height: 180.0,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.wifi_off_rounded,
                                color: CustomColors.primaryCream,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Unable to load image',
                                style: TextStyle(
                                  color: CustomColors.primaryCream
                                      .withValues(alpha: .7),
                                  fontSize: 14,
                                  fontFamily: 'OutfitRegular',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
                  : Image.asset(
                      theme['image']!,
                      fit: BoxFit.cover,
                      height: 180.0,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        // Show offline fallback for asset images too
                        return Container(
                          color: const Color(0xFF222122),
                          height: 180.0,
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.image_not_supported_rounded,
                                color: CustomColors.primaryCream,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Image not available',
                                style: TextStyle(
                                  color: CustomColors.primaryCream
                                      .withValues(alpha: .7),
                                  fontSize: 14,
                                  fontFamily: 'OutfitRegular',
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFF222122),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20.0),
                  bottomRight: Radius.circular(20.0),
                ),
              ),
              child: Text(
                (theme['title'] ?? 'Style Unavailable').toUpperCase(),
                style: const TextStyle(
                  color: CustomColors.secondaryBrown,
                  fontSize: 16,
                  fontFamily: "OutfitMedium",
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundImages() {
    return Stack(
      children: [
        Positioned(
          top: -10,
          right: 0,
          child: Image.asset(
            'images/home_top_right.png',
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: child,
              );
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Image.asset(
            'images/home_bottom.png',
            frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
              return AnimatedOpacity(
                opacity: frame == null ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: child,
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMainContent(
      List<Map<String, String>> themeData, ThemeProvider themeProvider) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildHeaderText(),
            const SizedBox(height: 20.0),
            SizedBox(
              height: 248,
              child: _buildCarousel(themeData),
            ),
            const SizedBox(height: 15.0),
            _buildPageIndicators(themeData),
            _buildInfoBox(themeData, themeProvider),
            _buildDivider(),
            _buildCreateStyleButton(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0D0C0D),
      drawer: Sidebar(
        selectedIndex: 0,
        onItemSelected: (index) {},
      ),
      body: Stack(
        children: [
          _buildBackgroundImages(),
          if (_isLoading)
            _buildLoadingIndicator()
          else
            Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                final themeData = showStatic
                    ? StaticThemeData.defaultThemes
                    : getThemeData(themeProvider);

                return AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: 1.0,
                  child: _buildMainContent(themeData, themeProvider),
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildCarousel(List<Map<String, String>> themeData) {
    return carousel.CarouselSlider.builder(
      options: carousel.CarouselOptions(
        autoPlay: false,
        viewportFraction: 0.69,
        enableInfiniteScroll: true,
        disableCenter: true,
        onPageChanged: (index, reason) {
          setState(() => currentImageIndex = index);
        },
        enlargeCenterPage: true,
        enlargeFactor: 0.35,
      ),
      itemCount: themeData.length,
      itemBuilder: (context, index, realIndex) {
        final theme = themeData[index];
        return _buildImageSliderItem(theme, index == currentImageIndex);
      },
    );
  }

  Widget _buildPageIndicators(List<Map<String, String>> themeData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: themeData.asMap().entries.map((entry) {
        return Container(
          width: 8.0,
          height: 8.0,
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: currentImageIndex == entry.key
                  ? CustomColors.primaryCream
                  : CustomColors.primaryCream.withValues(alpha: 0.5)),
        );
      }).toList(),
    );
  }

  Widget _buildInfoBox(
      List<Map<String, String>> themeData, ThemeProvider themeProvider) {
    // if (!isAuth) {
    //   return ArtStyleInfoBox(
    //     title: 'Login Required',
    //     description: 'Please login to create and stylize images.',
    //     onPressed: () {
    //       Navigator.pushNamed(context, '/login');
    //     },
    //   );
    // }
    if (showStatic ||
        themeData.isEmpty ||
        currentImageIndex >= themeData.length) {
      return ArtStyleInfoBox(
        title:
            themeData.isNotEmpty ? themeData[0]['title'] ?? '' : 'Offline Mode',
        description: 'Please connect to internet to create and stylize images.',
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Please check your internet connection to continue',
                style: TextStyle(
                  color: CustomColors.primaryCream,
                  fontFamily: 'OutfitRegular',
                ),
              ),
              backgroundColor: Color(0xFF333333),
              duration: Duration(seconds: 3),
            ),
          );
        },
      );
    }

    return ArtStyleInfoBox(
      title: themeData[currentImageIndex]['title'] ?? '',
      description: themeData[currentImageIndex]['description'] ?? '',
      onPressed: () {
        try {
          final currentTheme = themeProvider.randomThemes[currentImageIndex];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectStylePage(
                styleImage: currentTheme.themeImages.first,
                styleThemeTitle: currentTheme.title,
              ),
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Unable to load style. Please check your connection.',
                style: TextStyle(
                  color: CustomColors.primaryCream,
                  fontFamily: 'OutfitRegular',
                ),
              ),
              backgroundColor: Color(0xFF333333),
              duration: Duration(seconds: 3),
            ),
          );
        }
      },
    );
  }

  Widget _buildDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.2,
              top: 4,
            ),
            child: const Divider(
              color: CustomColors.primaryWhite,
              thickness: 1.0,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            'or',
            style: TextStyle(
              color: CustomColors.primaryWhite,
              fontSize: 18.0,
              fontFamily: 'OutfitMedium',
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.2,
              top: 4,
            ),
            child: const Divider(
              color: CustomColors.primaryWhite,
              thickness: 1.0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateStyleButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: ElevatedButton(
        onPressed: !isAuth
            ? () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Please login to create styles',
                      style: TextStyle(
                        color: CustomColors.primaryCream,
                        fontFamily: 'OutfitRegular',
                      ),
                    ),
                    backgroundColor: Color(0xFF333333),
                    duration: Duration(seconds: 3),
                  ),
                );
              }
            : () {
                if (showStatic) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please check your internet connection',
                        style: TextStyle(
                          color: CustomColors.primaryCream,
                          fontFamily: 'OutfitRegular',
                        ),
                      ),
                      backgroundColor: Color(0xFF333333),
                      duration: Duration(seconds: 3),
                    ),
                  );
                  return;
                }
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SelectStylePage(
                      styleImage: '',
                      styleThemeTitle: '',
                    ),
                  ),
                );
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: isAuth
              ? CustomColors.primaryCream
              : CustomColors.primaryCream.withValues(alpha: .5),
          foregroundColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 32.0,
            vertical: 8.0,
          ),
        ),
        child: Text(
          isAuth ? 'Create your own style' : 'Login to create',
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'OutfitSemiBold',
            color: CustomColors.primaryBlack,
          ),
        ),
      ),
    );
  }
}
