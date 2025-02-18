import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Pages/OnBoarding/on_boarding_page1.dart';
import 'package:gdsc_artwork/Pages/OnBoarding/on_boarding_page2.dart';
import 'package:gdsc_artwork/Pages/OnBoarding/on_boarding_page3.dart';
import 'package:gdsc_artwork/Pages/OnBoarding/on_boarding_page4.dart';
import 'package:gdsc_artwork/Pages/OnBoarding/on_boarding_page5.dart';
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
      body: Stack(
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
                        ? CustomColors.primaryCream
                        : CustomColors.primaryCream.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
