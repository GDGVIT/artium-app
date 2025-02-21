import 'package:flutter/material.dart' hide CarouselController;
import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Constants/colors.dart';
import 'package:gdsc_artwork/Pages/select_style_page.dart';
import 'package:gdsc_artwork/UIComponents/sidebar.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:gdsc_artwork/UIComponents/art_style_info_box.dart';
import 'package:provider/provider.dart';
import 'package:gdsc_artwork/Providers/theme_provider.dart';
import 'package:gdsc_artwork/Data/theme_data.dart';

String? baseUrl = BaseUrl.baseUrl;

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().fetchThemes();
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0D0C0D),
      drawer: Sidebar(
        selectedIndex: 0,
        onItemSelected: (index) {},
      ),
      body: Stack(
        children: [
          Positioned(
            top: -10,
            right: 0,
            child: Image.asset('images/home_top_right.png'),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Image.asset('images/home_bottom.png'),
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              final themeData = getThemeData(themeProvider);

              return Padding(
                padding: const EdgeInsets.only(top: 25.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Wrap(
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
                          Text('art styles.',
                              style: TextStyle(
                                color: CustomColors.primaryWhite,
                                fontSize: 24.0,
                                fontFamily: 'OutfitMedium',
                              )),
                        ],
                      ),
                      const Wrap(
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
                          Text('images.',
                              style: TextStyle(
                                color: CustomColors.primaryWhite,
                                fontSize: 24.0,
                                fontFamily: 'OutfitMedium',
                              )),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 248,
                        child: buildImageSlider(themeData),
                      ),
                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: themeData.asMap().entries.map((entry) {
                          return GestureDetector(
                            child: Container(
                              width: 8.0,
                              height: 8.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: currentImageIndex == entry.key
                                    ? Colors.grey
                                    : Colors.grey.withOpacity(0.5),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      ArtStyleInfoBox(
                        title: themeData[currentImageIndex]['title'] ?? '',
                        description:
                            themeData[currentImageIndex]['description'] ?? '',
                        onPressed: () {
                          final currentTheme =
                              themeProvider.randomThemes[currentImageIndex];
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectStylePage(
                                styleImage: currentTheme.themeImages.first,
                                styleThemeTitle: currentTheme.title,
                              ),
                            ),
                          );
                        },
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.2,
                                  top: 4),
                              child: Divider(
                                color: CustomColors.primaryWhite,
                                thickness: 1.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
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
                                  right:
                                      MediaQuery.of(context).size.width * 0.2,
                                  top: 4),
                              child: Divider(
                                color: CustomColors.primaryWhite,
                                thickness: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectStylePage(
                                styleImage: '',
                                styleThemeTitle: '',
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryCream,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 8.0),
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontFamily: "OutfitMedium",
                          ),
                        ),
                        child: const Text(
                          'Create your own style',
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'OutfitSemiBold',
                            color: CustomColors.primaryBlack,
                          ),
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
    );
  }

  Widget buildImageSlider(List<Map<String, String>> themeData) {
    return carousel.CarouselSlider.builder(
      options: carousel.CarouselOptions(
        autoPlay: false,
        viewportFraction: 0.69,
        enableInfiniteScroll: true,
        disableCenter: true,
        onPageChanged: (index, reason) {
          setState(() {
            currentImageIndex = index;
          });
        },
        enlargeCenterPage: true,
        enlargeFactor: 0.35,
      ),
      itemCount: themeData.length,
      itemBuilder: (context, index, realIndex) {
        final theme = themeData[index];
        final isCurrent = index == currentImageIndex;

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
                      ? Image.network(
                          theme['image']!,
                          fit: BoxFit.cover,
                          height: 180.0,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => Image.asset(
                            StaticThemeData.defaultThemes[index]['image']!,
                            fit: BoxFit.cover,
                            height: 180.0,
                            width: double.infinity,
                          ),
                        )
                      : Image.asset(
                          theme['image']!,
                          fit: BoxFit.cover,
                          height: 180.0,
                          width: double.infinity,
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
                  child: Column(
                    children: [
                      Text(
                        (theme['title'] ?? '').toUpperCase(),
                        style: const TextStyle(
                          color: CustomColors.secondaryBrown,
                          fontSize: 16,
                          fontFamily: "OutfitMedium",
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4.0),
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
}
