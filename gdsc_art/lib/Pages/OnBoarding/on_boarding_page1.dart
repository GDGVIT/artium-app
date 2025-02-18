import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/colors.dart';

class OnBoardingPage1 extends StatelessWidget {
  const OnBoardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF1B191B), Color(0xFF2E2C2E)],
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned(
            bottom: size.height * 0.015,
            right: size.width * 0.001,
            child: Opacity(
              opacity: 0.3,
              child: SvgPicture.asset(
                'images/onb1-1.svg',
                fit: BoxFit.fitWidth,
                colorFilter: const ColorFilter.matrix([
                  0.9,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0.9,
                  0,
                  0,
                  0,
                  0,
                  0,
                  0.9,
                  0,
                  0,
                  0,
                  0,
                  0,
                  1,
                  0,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -size.height * 0.01,
            left: -size.width * 0.9,
            child: Transform.rotate(
              angle: (3.14 / 180),
              child: Opacity(
                opacity: 0.8,
                child: SizedBox(
                  width: 800,
                  height: 400,
                  child: SvgPicture.asset('images/onb1-2.svg'),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.65,
            left: size.width * 0.3,
            child: Transform.rotate(
              angle: -10 * (3.14 / 180),
              child: Opacity(
                opacity: 0.7,
                child: SizedBox(
                  width: 400,
                  height: 350,
                  child: SvgPicture.asset('images/onb1-3.svg'),
                ),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Discover ',
                      style: TextStyle(
                        color: CustomColors.primaryCream,
                        fontFamily: 'Outfit',
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'historic',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Outfit',
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'and contemporary',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Outfit',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              const Text(
                'art styles.',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Outfit',
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              SizedBox(
                height: 350,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      right: -size.width * 0.4,
                      child: Transform.scale(
                        scale: 0.95,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF151315).withOpacity(0.75),
                                blurRadius: 22,
                                spreadRadius: 2,
                                offset: const Offset(0, 5),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: -2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            color: const Color(0xFF151315).withOpacity(0.75),
                          ),
                          child: const ArtCard(
                            imageUrl: 'images/img-1.png',
                            title: 'Retro Pop',
                            opacity: 0.7,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: -size.width * 0.4,
                      child: Transform.scale(
                        scale: 0.95,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    const Color(0xFF151315).withOpacity(0.75),
                                blurRadius: 22,
                                spreadRadius: 2,
                                offset: const Offset(0, 5),
                              ),
                              BoxShadow(
                                color: Colors.black.withOpacity(0.5),
                                blurRadius: 15,
                                spreadRadius: -2,
                                offset: const Offset(0, 2),
                              ),
                            ],
                            color: const Color(0xFF151315).withOpacity(0.75),
                          ),
                          child: const ArtCard(
                            imageUrl: 'images/img-2.png',
                            title: 'Impressionism',
                            opacity: 0.7,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      height: size.height * 0.45,
                      child: Transform.scale(
                        scale: 1,
                        child: const ArtCard(
                          imageUrl: 'images/sampleImage2.png',
                          title: 'POST-IMPRESSION',
                          opacity: 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ArtCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final double opacity;

  const ArtCard(
      {super.key,
      required this.imageUrl,
      required this.title,
      required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Opacity(
            opacity: opacity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  imageUrl,
                  width: 260,
                  height: 180,
                  fit: BoxFit.cover,
                ),
                Container(
                  width: 260,
                  height: 50,
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: CustomColors.secondaryBlack,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Text(
                    title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CustomColors.secondaryCream,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
