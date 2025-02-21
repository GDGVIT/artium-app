// import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../Constants/colors.dart';
import '../Providers/theme_provider.dart';

String? baseUrl = BaseUrl.baseUrl;

class DailyTheme extends StatefulWidget {
  const DailyTheme({super.key});

  @override
  State<DailyTheme> createState() => _DailyThemeState();
}

class _DailyThemeState extends State<DailyTheme> {
  bool _showLearnMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().fetchThemeOfDay();
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: Consumer<ThemeProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (provider.hasError) {
              return Center(
                child: Text(
                  provider.errorMessage ?? 'Error loading theme',
                  style: const TextStyle(color: CustomColors.primaryWhite),
                ),
              );
            }

            final theme = provider.theme;
            if (theme == null) return const SizedBox();

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Column(
                      children: [
                        if (!_showLearnMore)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                const Text(
                                  'Theme of the Day',
                                  style: TextStyle(
                                    color: CustomColors.primaryCream,
                                    fontFamily: "OutfitMedium",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 7.0),
                                Text(
                                  theme.title.toUpperCase(),
                                  style: const TextStyle(
                                    color: CustomColors.primaryBrown,
                                    fontFamily: "OutfitRegular",
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        if (_showLearnMore)
                          Row(
                            children: [
                              IconButton(
                                onPressed: () =>
                                    setState(() => _showLearnMore = false),
                                icon: const Icon(
                                  Icons.arrow_back_ios,
                                  color: CustomColors.primaryCream,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  theme.title.toUpperCase(),
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: CustomColors.primaryCream,
                                    fontFamily: "OutfitBold",
                                    fontSize: 26,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48.0),
                            ],
                          ),
                        const SizedBox(height: 20.0),
                        // CardSwiperCarousel(images: theme.themeImages),
                        // ThemeCarousel(images: theme.themeImages),
                        ThemeCarouselV2(images: theme.themeImages),
                        const SizedBox(height: 45.0),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: InfoBoxWithButtons(
                            title: theme.title,
                            description: theme.description,
                            onUseStyle: () {},
                            onLearnMore: () {
                              if (theme.history.isNotEmpty) {
                                setState(() => _showLearnMore = true);
                              }
                            },
                            showLearnMore: theme.history.isNotEmpty,
                          ),
                        ),
                        if (_showLearnMore) ...[
                          const SizedBox(height: 100.0),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                            child: LearnMore(
                              imagePath: theme.workImages.first,
                              title: theme.workTitle,
                              description: theme.workDescription,
                              infoLink: theme.infoLink,
                            ),
                          ),
                          SizedBox(height: 62.0),
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                stops: [
                                  0.0,
                                  1.0,
                                ],
                                colors: [
                                  CustomColors.primaryBrown,
                                  CustomColors.secondaryCream
                                ],
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 6,
                                  child: Image.asset('images/swirl1.png'),
                                ),
                                Positioned(
                                  top: 67,
                                  right: 0,
                                  child: Image.asset('images/swirl2.png'),
                                ),
                                Positioned(
                                  left: 0,
                                  top: 396,
                                  child: Image.asset('images/swirl3.png'),
                                ),
                                Positioned(
                                  right: 0,
                                  top: 823,
                                  child: Image.asset('images/swirl4.png'),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 24.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              'historic pieces of\n${theme.history[0].artist.name}'
                                                  .toUpperCase(),
                                              style: const TextStyle(
                                                color: Color(0xff161516),
                                                fontFamily: "OutfitSemiBold",
                                                fontSize: 24,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal:
                                                      MediaQuery.of(context)
                                                              .size
                                                              .width *
                                                          0.25),
                                              child: const Divider(
                                                color: Color(0xff161516),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      for (var history in theme.history) ...[
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 12.0),
                                          child: Container(
                                            padding: const EdgeInsets.all(32),
                                            decoration: BoxDecoration(
                                              color:
                                                  CustomColors.secondaryBlack,
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(18),
                                                  child:
                                                      FadeInImage.assetNetwork(
                                                    placeholder:
                                                        'images/sampleLogo.png',
                                                    image:
                                                        '$baseUrl${history.src}',
                                                    height: 231,
                                                    width: double.infinity,
                                                    fit: BoxFit.cover,
                                                    imageErrorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        Container(
                                                      height: 231,
                                                      width: double.infinity,
                                                      color: Colors.grey[300],
                                                      child: const Icon(
                                                          Icons.error),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16,
                                                          bottom: 12.0),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        history.artist.name
                                                            .toUpperCase(),
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              'OutfitRegular',
                                                          color: CustomColors
                                                              .primaryCream,
                                                          fontSize: 16,
                                                        ),
                                                      ),
                                                      Text(
                                                          history.artist.period,
                                                          style:
                                                              const TextStyle(
                                                            fontFamily:
                                                                'OutfitRegular',
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                          ))
                                                    ],
                                                  ),
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: theme.workTitle,
                                                        style: const TextStyle(
                                                          color: CustomColors
                                                              .primaryCream,
                                                          fontFamily:
                                                              'OutfitMedium',
                                                          fontSize: 16,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationThickness:
                                                              2,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            ', ${history.art.year}',
                                                        style: const TextStyle(
                                                          color: CustomColors
                                                              .primaryCream,
                                                          fontFamily:
                                                              'OutfitLight',
                                                          fontSize: 16,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          decoration:
                                                              TextDecoration
                                                                  .underline,
                                                          decorationThickness:
                                                              2,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 16.0),
                                      ]
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (!_showLearnMore) ...[
                          const SizedBox(height: 40.0),
                          Container(
                            decoration: BoxDecoration(
                                color: Color(0xff141414),
                                borderRadius: BorderRadius.circular(32)),
                            padding: EdgeInsets.symmetric(
                                vertical: 32, horizontal: 8),
                            child: Column(
                              children: [
                                const Text(
                                  "OTHER THEMES",
                                  style: TextStyle(
                                    color: Color(0xffEAD0B3),
                                    fontFamily: "OutfitMedium",
                                    fontSize: 24,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                                const OtherThemes(),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class ThemeCarousel extends StatefulWidget {
  final List<String> images;

  const ThemeCarousel({super.key, required this.images});

  @override
  State<ThemeCarousel> createState() => _ThemeCarouselState();
}

class _ThemeCarouselState extends State<ThemeCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: 355.0,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 290.0,
                    left: 10.0,
                    right: 10.0,
                    child: _buildImageLayer(
                      widget.images[index],
                      height: 80.0,
                      opacity: 0.6,
                      blur: 3.0,
                    ),
                  ),
                  Positioned(
                    top: 320.0,
                    left: 20.0,
                    right: 20.0,
                    child: _buildImageLayer(
                      widget.images[index],
                      height: 60.0,
                      opacity: 0.3,
                      blur: 2.0,
                    ),
                  ),
                  _buildImageLayer(
                    widget.images[index],
                    height: 355.0,
                    opacity: 1.0,
                    blur: 0.0,
                  ),
                ],
              );
            },
          ),
        ),
        Positioned(
          right: 10,
          top: 0,
          bottom: 0,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.images.length,
                (index) => Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentPage == index
                        ? CustomColors.primaryCream
                        : CustomColors.primaryCream.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageLayer(
    String imageUrl, {
    required double height,
    required double opacity,
    required double blur,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.0),
      child: Stack(
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.2),
              BlendMode.darken,
            ),
            child: Opacity(
              opacity: opacity,
              child: FadeInImage.assetNetwork(
                placeholder: 'images/sampleLogo.png',
                image: '$baseUrl$imageUrl',
                height: height,
                width: double.infinity,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) => Container(
                  height: height,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
                fadeInDuration: const Duration(milliseconds: 300),
                placeholderFit: BoxFit.cover,
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.transparent,
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: const [0.8, 1.0],
                ),
              ),
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-0.5, -0.5),
                  end: const Alignment(1.0, 1.0),
                  colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black.withOpacity(0.9),
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OtherThemes extends StatefulWidget {
  const OtherThemes({super.key});

  @override
  State<OtherThemes> createState() => _OtherThemesState();
}

class _OtherThemesState extends State<OtherThemes> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().fetchThemes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, provider, _) {
        final themes = provider.randomThemes;

        return SizedBox(
          height: 600,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: themes.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) {
                final theme = themes[index];
                return Card(
                  color: Color(0xff141414),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    margin: const EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16.0),
                              bottom: Radius.circular(16),
                            ),
                            child: FadeInImage.assetNetwork(
                              placeholder: 'images/sampleLogo.png',
                              image: baseUrl! + theme.themeImages.first,
                              fit: BoxFit.cover,
                              imageErrorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.error,
                                      color: Colors.white),
                                );
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            theme.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: CustomColors.primaryCream,
                              fontFamily: "OutfitMedium",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class InfoBoxWithButtons extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onUseStyle;
  final VoidCallback onLearnMore;
  final bool showLearnMore;

  const InfoBoxWithButtons({
    super.key,
    required this.title,
    required this.description,
    required this.onUseStyle,
    required this.onLearnMore,
    required this.showLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: CustomColors.secondaryBlack,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: CustomColors.primaryWhite,
              fontSize: 19.0,
              fontFamily: 'OutfitBold',
            ),
          ),
          const SizedBox(height: 20.0),
          Text(
            description,
            style: const TextStyle(
              color: CustomColors.primaryWhite,
              fontSize: 13.0,
              fontFamily: 'OutfitRegular',
            ),
          ),
          if (showLearnMore) ...[
            const SizedBox(height: 20.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: onUseStyle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryCream,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Use this style',
                    style: TextStyle(
                      color: CustomColors.secondaryBlack,
                      fontFamily: 'OutfitSemiBold',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onLearnMore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.secondaryBlack,
                    foregroundColor: CustomColors.primaryCream,
                    side: const BorderSide(color: CustomColors.primaryCream),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Learn more',
                    style: TextStyle(
                      color: CustomColors.primaryCream,
                      fontFamily: 'OutfitSemiBold',
                    ),
                  ),
                ),
              ],
            ),
          ]
        ],
      ),
    );
  }
}

class LearnMore extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;
  final String infoLink;

  const LearnMore({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
    required this.infoLink,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 200),
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: CustomColors.secondaryBlack,
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.primaryWhite,
                      fontSize: 20.0,
                      fontFamily: 'OutfitBold',
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  description,
                  style: const TextStyle(
                    color: CustomColors.primaryWhite,
                    fontSize: 14.0,
                    fontFamily: 'OutfitRegular',
                  ),
                ),
                const SizedBox(height: 24.0),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await launchUrl(Uri.parse(infoLink));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.secondaryBlack,
                      foregroundColor: CustomColors.primaryCream,
                      side: const BorderSide(color: CustomColors.primaryCream),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(
                          width: 2,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Learn more',
                      style: TextStyle(
                        color: CustomColors.primaryCream,
                        fontFamily: 'OutfitSemiBold',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          ),
          Positioned(
            top: -50,
            left: 16,
            right: 16,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/sampleLogo.png',
                image: baseUrl! + imagePath,
                height: 300,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) => Container(
                  height: 300,
                  color: Colors.grey[300],
                  child: const Icon(Icons.error),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ThemeCarouselV2 extends StatefulWidget {
  final List<String> images;

  const ThemeCarouselV2({super.key, required this.images});

  @override
  State<ThemeCarouselV2> createState() => _ThemeCarouselV2State();
}

class _ThemeCarouselV2State extends State<ThemeCarouselV2> {
  late final PageController _controller;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 355.0,
      child: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            scrollDirection: Axis.vertical,
            itemCount: widget.images.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
            },
            itemBuilder: (context, index) {
              return AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  double offset = 0.0;
                  if (_controller.position.haveDimensions) {
                    offset = _controller.page! - index;
                  }

                  offset = offset.clamp(-1.0, 1.0);

                  final scale = 1 - (offset.abs() * 0.3);
                  final opacity = 1 - (offset.abs() * 0.5);

                  return Opacity(
                    opacity: opacity,
                    child: Transform.scale(
                      scale: scale,
                      child: child,
                    ),
                  );
                },
                child: _buildLayeredImage(widget.images[index]),
              );
            },
          ),
          Positioned(
            right: 10,
            top: 0,
            bottom: 0,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(
                  widget.images.length,
                  (index) => Container(
                    width: 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _currentPage == index
                          ? CustomColors.primaryCream
                          : CustomColors.primaryCream.withOpacity(0.5),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayeredImage(String imageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.2),
                BlendMode.darken,
              ),
              child: FadeInImage.assetNetwork(
                placeholder: 'images/sampleLogo.png',
                image: '$baseUrl$imageUrl',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                    stops: const [0.8, 1.0],
                  ),
                ),
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: const Alignment(-0.5, -0.5),
                    end: const Alignment(1.0, 1.0),
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.9),
                    ],
                    stops: const [0.0, 0.6, 1.0],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CardSwiperCarousel extends StatefulWidget {
//   final List<String> images;
//   const CardSwiperCarousel({super.key, required this.images});

//   @override
//   State<CardSwiperCarousel> createState() => _CardSwiperCarouselState();
// }

// class _CardSwiperCarouselState extends State<CardSwiperCarousel> {
//   final SwiperController _controller = SwiperController();

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: 355.0,
//       child: Swiper(
//         allowImplicitScrolling: true,
//         itemCount: widget.images.length,
//         controller: _controller,
//         axisDirection: AxisDirection.up,
//         viewportFraction: 0.6,
//         scale: 0.8,
//         itemHeight: 355.0,
//         itemWidth: MediaQuery.of(context).size.width,
//         scrollDirection: Axis.vertical,
//         itemBuilder: (context, index) {
//           return _buildLayeredImage(widget.images[index]);
//         },
//         layout: SwiperLayout.STACK,
//         pagination: SwiperPagination(
//           alignment: Alignment.centerRight,
//           margin: const EdgeInsets.only(right: 10),
//           builder: DotSwiperPaginationBuilder(
//             color: CustomColors.primaryCream.withOpacity(0.5),
//             activeColor: CustomColors.primaryCream,
//             size: 8.0,
//             activeSize: 8.0,
//             space: 4.0,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildLayeredImage(String imageUrl) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(18),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(18),
//         child: Stack(
//           fit: StackFit.expand,
//           children: [
//             ColorFiltered(
//               colorFilter: ColorFilter.mode(
//                 Colors.black.withOpacity(0.2),
//                 BlendMode.darken,
//               ),
//               child: FadeInImage.assetNetwork(
//                 placeholder: 'images/sampleLogo.png',
//                 image: '$baseUrl$imageUrl',
//                 fit: BoxFit.cover,
//                 width: double.infinity,
//                 height: double.infinity,
//               ),
//             ),
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: Alignment.centerLeft,
//                     end: Alignment.centerRight,
//                     colors: [
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.8),
//                     ],
//                     stops: const [0.8, 1.0],
//                   ),
//                 ),
//               ),
//             ),
//             Positioned.fill(
//               child: Container(
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     begin: const Alignment(-0.5, -0.5),
//                     end: const Alignment(1.0, 1.0),
//                     colors: [
//                       Colors.transparent,
//                       Colors.transparent,
//                       Colors.black.withOpacity(0.9),
//                     ],
//                     stops: const [0.0, 0.6, 1.0],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
