import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:artium/Pages/OnBoarding/on_boarding_page1.dart';
import 'package:artium/Pages/OnBoarding/on_boarding_page2.dart';
import 'package:artium/Pages/OnBoarding/on_boarding_page3.dart';
import 'package:artium/Pages/OnBoarding/on_boarding_page4.dart';
import 'package:artium/Pages/OnBoarding/on_boarding_page5.dart';
import '../../Constants/colors.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => Navigator.pushReplacementNamed(context, '/auth'),
            child: const Text(
              'Skip',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'OutfitRegular',
                color: CustomColors.primaryCream,
              ),
            ),
          ),
        ],
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SvgPicture.asset('images/logo.svg'),
              SizedBox(
                width: 12,
              ),
              const Text(
                'Artium',
                style: TextStyle(
                  fontSize: 24,
                  fontFamily: 'Outfit',
                  color: CustomColors.primaryWhite,
                  fontWeight: FontWeight.w200,
                ),
              ),
            ],
          ),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            fit: StackFit.expand,
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: const [
                  OnBoardingPage1(),
                  OnBoardingPage2(),
                  OnBoardingPage3(),
                  OnBoardingPage4(),
                  OnBoardingPage5(),
                ],
              ),
              // const Positioned(
              //   top: 40,
              //   left: 30,
              //   right: 30,
              //   child: Header(),
              // ),
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentPage == index
                            ? CustomColors.primaryWhite
                            : CustomColors.primaryWhite
                                .withValues(alpha: (0.5)),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
