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
    return Scaffold(
      backgroundColor: CustomColors.primaryBlack,
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

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  if (!_showLearnMore) ...[
                    const Text(
                      'THEME OF THE DAY',
                      style: TextStyle(
                        color: CustomColors.primaryCream,
                        fontFamily: "OutfitRegular",
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 5.0),
                    Text(
                      theme.title,
                      style: const TextStyle(
                        color: CustomColors.primaryBrown,
                        fontFamily: "OutfitRegular",
                        fontSize: 20,
                      ),
                    ),
                  ],
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
                            theme.title,
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
                  ThemeCarousel(images: theme.themeImages),
                  const SizedBox(height: 45.0),
                  InfoBoxWithButtons(
                    title: theme.title,
                    description: theme.description,
                    onUseStyle: () {},
                    onLearnMore: () {
                      setState(() => _showLearnMore = !_showLearnMore);
                    },
                  ),
                  if (_showLearnMore) ...[
                    const SizedBox(height: 100.0),
                    LearnMore(
                      imagePath: theme.workImages.first,
                      title: theme.workTitle,
                      description: theme.workDescription,
                      infoLink: theme.infoLink,
                    ),
                  ],
                  if (!_showLearnMore) ...[
                    const SizedBox(height: 40.0),
                    const Text(
                      "OTHER THEMES",
                      style: TextStyle(
                        color: CustomColors.primaryWhite,
                        fontFamily: "OutfitRegular",
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const OtherThemes(),
                  ],
                ],
              ),
            ),
          );
        },
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
      child: ColorFiltered(
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
                  color: Colors.black,
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

  const InfoBoxWithButtons({
    super.key,
    required this.title,
    required this.description,
    required this.onUseStyle,
    required this.onLearnMore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: CustomColors.secondaryBlack,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(
              color: CustomColors.primaryWhite,
              fontSize: 19.0,
              fontFamily: 'OutfitBold',
            ),
          ),
          const SizedBox(height: 10.0),
          Text(
            description,
            style: const TextStyle(
              color: CustomColors.primaryWhite,
              fontSize: 13.0,
              fontFamily: 'OutfitRegular',
            ),
          ),
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
                child: const Text('Use this style'),
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
                child: const Text('Learn more'),
              ),
            ],
          ),
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
        color: CustomColors.tertiaryBlack,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 200),
            padding: const EdgeInsets.all(16.0),
            decoration: const BoxDecoration(
              color: CustomColors.tertiaryBlack,
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
                      backgroundColor: CustomColors.primaryCream,
                      foregroundColor: CustomColors.primaryBlack,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                        vertical: 12.0,
                      ),
                    ),
                    child: const Text(
                      'Learn More',
                      style: TextStyle(
                        fontFamily: 'OutfitMedium',
                        fontSize: 14.0,
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
                width: double.infinity,
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
