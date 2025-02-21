import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:artium/UIComponents/header.dart';
import '../../Constants/colors.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
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
              top: -size.height * 0.1,
              left: -size.width * 0.3,
              child: Transform.rotate(
                angle: -25 * (3.14 / 180),
                child: SizedBox(
                  width: 500,
                  height: 600,
                  child: SvgPicture.asset(
                    'images/morh-2.svg',
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: -size.height * 0.01,
              left: -size.width * 0.01,
              child: Transform.rotate(
                angle: (3.14 / 180),
                child: Opacity(
                  opacity: 0.50,
                  child: SizedBox(
                    width: 220,
                    height: 220,
                    child: SvgPicture.asset('images/morh-1.svg'),
                  ),
                ),
              ),
            ),

            Positioned(
              top: size.height * 0.15,
              right: size.width * 0.02,
              child: Transform.rotate(
                angle: -10 * (3.14 / 180),
                child: Opacity(
                  opacity: 0.50,
                  child: SizedBox(
                    width: 150,
                    height: 200,
                    child: SvgPicture.asset('images/morh-4.svg'),
                  ),
                ),
              ),
            ),

            Positioned(
              bottom: size.height * 0.001,
              right: -size.width * 0.2,
              child: SvgPicture.asset(
                'images/morh-3.svg',
                fit: BoxFit.fitWidth,
              ),
            ),

            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(
                size.width * 0.08,
                size.height * 0.06,
                size.width * 0.08,
                size.height * 0.06,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Header(),
                  SizedBox(height: size.height * 0.15),
                  const Text(
                    'Welcome to\nArtium!',
                    style: TextStyle(
                      fontSize: 55,
                      fontFamily: 'Outfit',
                      color: CustomColors.primaryCream,
                      height: 1.0,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Discover • Create • Inspire',
                    style: TextStyle(
                      fontSize: 23,
                      fontFamily: 'Outfit',
                      color: CustomColors.primaryBrown,
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushReplacementNamed(
                          context, '/onboarding'),
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
                        'Get Started',
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
      ),
    );
  }
}
