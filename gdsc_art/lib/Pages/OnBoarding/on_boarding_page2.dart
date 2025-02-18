import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../Constants/colors.dart';

class OnBoardingPage2 extends StatelessWidget {
  const OnBoardingPage2({super.key});

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
            bottom: size.height * 0.68,
            right: size.width * 0.5,
            child: Transform.rotate(
              angle: -10 * (3.14 / 180),
              child: Opacity(
                opacity: 0.6,
                child: SizedBox(
                  child: SvgPicture.asset(
                    'images/onb2.svg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: size.height * 0.0395,
            right: size.width * 0.9,
            child: Opacity(
              opacity: 0.3,
              child: Transform.rotate(
                angle: 1,
                child: SvgPicture.asset(
                  'images/onb1-1.svg',
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.8,
            child: SvgPicture.asset('images/onb2-1.svg'),
          ),
          Positioned(
            top: size.height * 0.4,
            left: size.width * 0.9,
            child: SvgPicture.asset('images/onb3-3.svg'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Explore ',
                      style: TextStyle(
                        color: CustomColors.primaryCream,
                        fontFamily: 'Outfit',
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(
                      text: 'artists and',
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
                    'their iconic pieces.',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Outfit',
                      fontSize: 32,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 90,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  height: size.height * 0.4,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Spacer(),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                color: CustomColors.primaryBrown,
                                child: Image.asset(
                                  'images/onb2-3.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'VINCENT VAN GOGH',
                              style: TextStyle(
                                color: CustomColors.primaryCream,
                                fontFamily: 'Outfit',
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'Dutch, 1853 - 1890',
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Outfit',
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            const Text(
                              'The Starry Night , 1939',
                              style: TextStyle(
                                shadows: [
                                  Shadow(
                                    color: CustomColors.primaryCream,
                                    offset: Offset(0, -5),
                                  )
                                ],
                                decoration: TextDecoration.underline,
                                decorationColor: CustomColors.primaryCream,
                                fontWeight: FontWeight.bold,
                                color: Colors.transparent,
                                fontSize: 12,
                                fontFamily: 'Outfit',
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/onb2-5.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Flexible(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: SizedBox(
                                  width: size.width * 0.45,
                                  child: Image.asset(
                                    'images/onb2-4.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Flexible(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.asset(
                                  'images/onb2-6.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
