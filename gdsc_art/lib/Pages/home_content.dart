import 'package:flutter/material.dart' hide CarouselController;
import 'package:gdsc_artwork/Constants/colors.dart';
import 'package:gdsc_artwork/Pages/select_style_page.dart';
import 'package:gdsc_artwork/UIComponents/sidebar.dart';
import 'package:carousel_slider/carousel_slider.dart' as carousel;
import 'package:gdsc_artwork/UIComponents/art_style_info_box.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int currentImageIndex = 0;
  final images = [
    'images/sampleImage1.png',
    'images/sampleImage2.png',
    'images/sampleImage3.png',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: Sidebar(
        selectedIndex: 0,
        onItemSelected: (index) {},
      ),
      body: Padding(
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
                        fontSize: 28.0,
                        fontFamily: 'OutfitMedium',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text('art styles.',
                        style: TextStyle(
                          color: CustomColors.primaryWhite,
                          fontSize: 28.0,
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
                        fontSize: 28.0,
                        fontFamily: 'OutfitMedium',
                      ),
                    ),
                    SizedBox(width: 10.0),
                    Text('images.',
                        style: TextStyle(
                          color: CustomColors.primaryWhite,
                          fontSize: 28.0,
                          fontFamily: 'OutfitMedium',
                        )),
                  ],
                ),
                const SizedBox(height: 20.0),
                SizedBox(
                  height: 248,
                  child: buildImageSlider(images),
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: images.asMap().entries.map((entry) {
                    return GestureDetector(
                      child: Container(
                        width: 8.0,
                        height: 8.0,
                        margin: const EdgeInsets.symmetric(horizontal: 4.0),
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
                  title: 'POST - IMPRESSIONISM',
                  description:
                      'Post-Impressionism is a predominantly French art movement that developed as a reaction against Impressionism and its concern for the naturalistic depiction of light and...',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SelectStylePage()),
                    );
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 2.0,
                        color: CustomColors.primaryBrown,
                        margin: const EdgeInsets.only(left: 50.0),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: const Text(
                        'or',
                        style: TextStyle(
                          color: CustomColors.primaryBrown,
                          fontSize: 18.0,
                          fontFamily: 'OutfitMedium',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 2.0,
                        color: CustomColors.primaryBrown,
                        margin: const EdgeInsets.only(right: 50.0),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: CustomColors.primaryCream,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25.0, vertical: 10.0),
                    textStyle: const TextStyle(
                      fontSize: 16.0,
                      fontFamily: "OutfitMedium",
                    ),
                  ),
                  child: const Text('Create Your Own Style'),
                ),
              ],
            ),
          )),
    );
  }

  Widget buildImageSlider(List<String> images) {
    return carousel.CarouselSlider.builder(
      options: carousel.CarouselOptions(
          autoPlay: false,
          viewportFraction: 0.65,
          enableInfiniteScroll: true,
          disableCenter: true,
          onPageChanged: (index, reason) {
            setState(() {
              currentImageIndex = index;
            });
          },
          enlargeCenterPage: true),
      itemCount: images.length,
      itemBuilder: (context, index, realIndex) {
        return Container(
          height: 350,
          margin: const EdgeInsets.symmetric(horizontal: 5.0),
          decoration: BoxDecoration(
            color: Colors.white,
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
                child: Image.asset(
                  images[index],
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
                child: const Column(
                  children: [
                    Text(
                      'Image Label',
                      style: TextStyle(
                        color: CustomColors.secondaryBrown,
                        fontSize: 16.0,
                        fontFamily: "OutfitMedium",
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 4.0),
                    Text(
                      'Subtitle or additional info',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: "OutfitRegular",
                        fontSize: 12.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
