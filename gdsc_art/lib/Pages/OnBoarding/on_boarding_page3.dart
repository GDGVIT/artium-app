import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/colors.dart';

class OnBoardingPage3 extends StatelessWidget {
  const OnBoardingPage3({super.key});

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
      child: Stack(children: [
        Positioned(
          bottom: size.height * 0.65,
          left: size.width * 0.3,
          child: Transform.rotate(
            angle: -10 * (3.14 / 180),
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  begin:
                      const Alignment(-0.5, -0.8), // Approximates 131 degrees
                  end: const Alignment(0.7, 0.7),
                  colors: const [
                    Color(0xFF161516),
                    Color(0xFF2A292A),
                  ],
                  stops: const [0.3156, 0.7603], // 31.56% and 76.03%
                ).createShader(bounds);
              },
              child: SizedBox(
                width: 400,
                height: 350,
                child: SvgPicture.asset(
                  'images/onb3-1.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcATop,
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: size.height * 0.4,
          right: size.width * 0.13,
          child: SvgPicture.asset('images/onb3-3.svg'),
        ),
        Positioned(
          top: size.height * 0.15,
          left: size.width * 0.01,
          child: Opacity(
            opacity: 0.7,
            child: SvgPicture.asset(
              'images/onb3-2.svg',
            ),
          ),
        ),
        Positioned(
          bottom: size.height * 0.22,
          right: size.width * 0.1,
          child: Opacity(
            opacity: 0.50,
            child: SizedBox(
              width: 100,
              height: 100,
              child: SvgPicture.asset('images/onb3-4.svg'),
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
                    text: 'Stylize ',
                    style: TextStyle(
                      color: CustomColors.primaryCream,
                      fontFamily: 'Outfit',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  TextSpan(
                    text: 'any image in',
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
                  "your favorite artist's",
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
              'style',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Outfit',
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 40),
            ImageLayoutView(
              smallImage1: 'images/rec-1.png',
              smallImage2: 'images/rec-3.png',
              largeOutputImage: 'images/rec-2.png',
            ),
            const SizedBox(height: 52),
            Text(
              ' - or your own style.',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Outfit',
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
      ]),
    );
  }
}

class ImageLayoutView extends StatelessWidget {
  final String smallImage1;
  final String smallImage2;
  final String largeOutputImage;

  const ImageLayoutView({
    super.key,
    required this.smallImage1,
    required this.smallImage2,
    required this.largeOutputImage,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image: AssetImage(smallImage1),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Text('+',
                  style: TextStyle(fontSize: 24, color: Colors.white)),
              const SizedBox(height: 8),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  image: DecorationImage(
                    image: AssetImage(smallImage2),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Icon(Icons.arrow_forward, size: 32, color: Colors.white),
          ),
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              image: DecorationImage(
                image: AssetImage(largeOutputImage),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
