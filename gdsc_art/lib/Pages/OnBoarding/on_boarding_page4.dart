import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/colors.dart';

class OnBoardingPage4 extends StatelessWidget {
  const OnBoardingPage4({super.key});

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
        children: [
          Positioned(
            bottom: size.height * 0.76,
            right: size.width * 0.5,
            child: SvgPicture.asset(
              'images/onb4-1.svg',
            ),
          ),

          Positioned(
            top: size.height * 0.18,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'Publish ',
                        style: TextStyle(
                          color: CustomColors.primaryCream,
                          fontFamily: 'Outfit',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'your',
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
                      "creations in ours",
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Outfit',
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    children: [
                      TextSpan(
                        text: 'gallery ',
                        style: TextStyle(
                          color: CustomColors.primaryCream,
                          fontFamily: 'Outfit',
                          fontSize: 32,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      TextSpan(
                        text: 'for the world',
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
                const Text(
                  'to see.',
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
          Positioned(
            top: size.height * 0.52,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'images/onb4-2.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
