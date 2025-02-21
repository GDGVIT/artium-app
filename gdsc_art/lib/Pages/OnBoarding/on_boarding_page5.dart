import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/colors.dart';

class OnBoardingPage5 extends StatelessWidget {
  const OnBoardingPage5({super.key});

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
        alignment: Alignment.center,
        children: [
          Positioned(
            top: size.height * 0.12,
            right: size.width * 0.2,
            child: Opacity(
              opacity: 0.50,
              child: SizedBox(
                child: SvgPicture.asset('images/onb-6.svg'),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.15,
            right: size.width * 0.1,
            child: Opacity(
              opacity: 0.50,
              child: SizedBox(
                child: SvgPicture.asset('images/onb-5.svg'),
              ),
            ),
          ),
          Positioned(
            left: -size.width * 0.15,
            top: size.height * 0.45,
            child: Opacity(
              opacity: 0.4,
              child: Transform.scale(
                scale: 0.9,
                child: Image.asset(
                  'images/51.png',
                  width: 200,
                  height: 280,
                ),
              ),
            ),
          ),
          Positioned(
            right: -size.width * 0.15,
            top: size.height * 0.45,
            child: Opacity(
              opacity: 0.4,
              child: Transform.scale(
                scale: 0.9,
                child: Image.asset(
                  'images/53.png',
                  width: 200,
                  height: 280,
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.4,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:(0.2)),
                    blurRadius: 15,
                    spreadRadius: 5,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Image.asset(
                'images/52.png',
                width: 200,
                height: 280,
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.78,
            child: SvgPicture.asset('images/onb5-1.svg'),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              size.width * 0.08,
              size.height * 0.06,
              size.width * 0.08,
              size.height * 0.06,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OnBoardingPage2Text(),
                SizedBox(
                  height: 380,
                ),
                Center(
                  child: ElevatedButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/auth'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomColors.primaryBrown,
                      foregroundColor: CustomColors.primaryWhite,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Start Creating',
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'OutfitMedium',
                      ),
                    ),
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

class OnBoardingPage2Text extends StatelessWidget {
  const OnBoardingPage2Text({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: const TextSpan(
            children: [
              TextSpan(
                text: "Like ",
                style: TextStyle(
                  color: CustomColors.primaryCream,
                  fontFamily: 'Outfit',
                  fontSize: 32,
                  fontWeight: FontWeight.w600,
                ),
              ),
              TextSpan(
                text: "others'",
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
              "creations and get",
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
          'inspired.',
          style: TextStyle(
            color: CustomColors.primaryCream,
            fontFamily: 'Outfit',
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
