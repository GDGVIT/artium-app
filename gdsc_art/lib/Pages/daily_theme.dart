import 'package:flutter/material.dart';
import '../Constants/Colors.dart';

class StackedImageCard extends StatelessWidget {
  final String imagePath;

  const StackedImageCard({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 290.0,
            left: 10.0,
            right: 10.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.0),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
                child: Container(
                    height: 80.0,
                    width: MediaQuery.of(context).size.width,
                    child: Opacity(
                      opacity: 0.6,
                      child: Image.asset(
                        imagePath,
                        height: 355.0,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
            ),
          ),
          Positioned(
            top: 320.0,
            left: 20.0,
            right: 20.0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.1),
                  BlendMode.darken,
                ),
                child: Container(
                  height: 60.0,
                  width: MediaQuery.of(context).size.width,
                  child: Opacity(
                    opacity: 0.3,
                    child: Image.asset(
                      imagePath,
                      height: 355.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: ColorFiltered(
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.15),
                BlendMode.darken,
              ),
              child: Image.asset(
                imagePath,
                height: 355.0,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const Positioned(
            bottom: 20.0,
            right: 20.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Opacity(
                  opacity: 1,
                  child: Text(
                    'FRIDA KAHLO',
                    style: TextStyle(
                      color: CustomColors.primaryCream,
                      fontFamily: "OutfitRegular",
                      fontSize: 16.0,
                    ),
                  ),
                ),
                Opacity(
                  opacity: 1,
                  child: Text(
                    'Butch 1953, 1890',
                    style: TextStyle(
                      fontFamily: "OutfitRegular",
                      color: CustomColors.primaryWhite,
                      fontSize: 12.0,
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                Opacity(
                  opacity: 1,
                  child: Text(
                    'The Two Fridas, 1939',
                    style: TextStyle(
                      color: CustomColors.primaryCream,
                      fontFamily: "OutfitRegolar",
                      fontSize: 14.0,
                      decoration: TextDecoration.underline,
                      decorationColor: CustomColors.primaryCream,
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class InfoBoxWithButtons extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onUseStyle;
  final VoidCallback onLearnMore;

  const InfoBoxWithButtons({
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
        mainAxisAlignment: MainAxisAlignment.center,
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
            textAlign: TextAlign.left,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18.0, vertical: 10.0),
                  textStyle: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
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

class DailyTheme extends StatefulWidget {
  @override
  _DailyThemeState createState() => _DailyThemeState();
}

class _DailyThemeState extends State<DailyTheme> {
  bool _showLearnMore = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBlack,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              if (!_showLearnMore)
                const Center(
                  child: Text(
                    'THEME OF THE DAY',
                    style: TextStyle(
                      color: CustomColors.primaryCream,
                      fontFamily: "OutfitRegular",
                      fontSize: 24,
                    ),
                  ),
                ),
              const SizedBox(height: 5.0),
              if (!_showLearnMore)
                const Center(
                  child: Text(
                    'Sunset Art',
                    style: TextStyle(
                      color: CustomColors.primaryBrown,
                      fontFamily: "OutfitRegular",
                      fontSize: 20,
                    ),
                  ),
                ),
              if (_showLearnMore)
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showLearnMore = false;
                        });
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: CustomColors.primaryCream,
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          'Sunset Art',
                          style: TextStyle(
                            color: CustomColors.primaryCream,
                            fontFamily: "OutfitBold",
                            fontSize: 26,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 48.0),
                  ],
                ),
              const SizedBox(height: 20.0),
              StackedImageCard(imagePath: 'images/themeSampleImage.png'),
              const SizedBox(height: 45.0),
              InfoBoxWithButtons(
                title: 'Sunset Art Style',
                description:
                    'Explore the beauty of sunset through different styles.',
                onUseStyle: () {},
                onLearnMore: () {
                  setState(() {
                    _showLearnMore = !_showLearnMore;
                  });
                },
              ),
              const SizedBox(height: 20.0),
              if (_showLearnMore)
                const LearnMore(
                  imagePath: 'images/fridakhalo.png',
                  title: 'FRIDA KAHLO',
                  description:
                      'Mexican painter known for her many portraits, self-portraits, and works inspired by the nature and artifacts of Mexico.',
                ),
              SizedBox(
                height: 40,
              ),
              const Text(
                "OTHER THEMES",
                style: TextStyle(
                  color: CustomColors.primaryWhite,
                  fontFamily: "OutfitRegular",
                  fontSize: 24,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              OtherThemes()
            ],
          ),
        ),
      ),
    );
  }
}

class LearnMore extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const LearnMore({
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 500,
          child: Stack(
            children: [
              Positioned(
                top: 250.0,
                left: 0,
                right: 0,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: CustomColors.tertiaryBlack,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        height: 50,
                      ),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: CustomColors.primaryWhite,
                          fontSize: 20.0,
                          fontFamily: 'OutfitBold',
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: CustomColors.primaryWhite,
                          fontSize: 14.0,
                          fontFamily: 'OutfitRegular',
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () {
                          // Handle learn more action
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CustomColors.primaryCream,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 12.0),
                          textStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        child: const Text('Learn more'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    imagePath,
                    height: 300.0,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20.0),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF9A8873), Color(0xFFEAD0B3)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: [
              const Text(
                'HISTORIC PIECES OF\nFRIDA KAHLO',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CustomColors.primaryBlack,
                  fontSize: 18.0,
                  fontFamily: 'OutfitMedium',
                ),
              ),
              const SizedBox(height: 4.0),
              Container(
                  height: 1.0, width: 100.0, color: CustomColors.primaryBlack),
              const SizedBox(height: 20.0),
              _buildArtSection(
                  context,
                  'images/sampleImage2.png',
                  'FRIDA KAHLO',
                  'Dutch, 1853 - 1890',
                  'The Broken Column, 1939'),
              const SizedBox(height: 20.0),
              _buildArtSection(
                  context,
                  'images/sampleImage2.png',
                  'FRIDA KAHLO',
                  'Dutch, 1853 - 1890',
                  'Self-Portrait with Thorn Necklace, 1940'),
              const SizedBox(height: 20.0),
              _buildArtSection(context, 'images/sampleImage2.png',
                  'FRIDA KAHLO', 'Dutch, 1853 - 1890', 'The Two Fridas, 1939'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildArtSection(BuildContext context, String imagePath,
      String artistName, String artistDetails, String artName) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: CustomColors.tertiaryBlack,
        borderRadius: BorderRadius.circular(20.0),
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18.0),
            child: Image.asset(
              imagePath,
              height: 180.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Padding around text
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artistName,
                  style: const TextStyle(
                    color: CustomColors.primaryWhite,
                    fontSize: 16.0,
                    fontFamily: 'OutfitBold',
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  artistDetails,
                  style: const TextStyle(
                    color: CustomColors.primaryWhite,
                    fontSize: 14.0,
                    fontFamily: 'OutfitRegular',
                  ),
                ),
                const SizedBox(height: 5.0),
                Text(
                  artName,
                  style: const TextStyle(
                    color: CustomColors.primaryCream,
                    fontSize: 14.0,
                    fontFamily: 'OutfitRegular',
                    decoration: TextDecoration.underline,
                    decorationColor: CustomColors.primaryCream,
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

class OtherThemes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 600,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GridView.builder(
            itemCount: 6,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.9,
            ),
            itemBuilder: (BuildContext context, int index) {
              return Card(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.all(6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16.0),
                            ),
                            child: Image.asset(
                              index % 2 == 0
                                  ? 'images/galleryImage1.png'
                                  : 'images/galleryImage2.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8, bottom: 8),
                          child: Text(
                            index % 2 == 0
                                ? 'Post - Impressionism'
                                : 'Abstractism',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: CustomColors.primaryCream,
                              fontWeight: FontWeight.bold,
                              fontFamily: "OutfitMedium",
                            ),
                          ),
                        ),
                      ],
                    ),
                  ));
            },
          ),
        ));
  }
}
