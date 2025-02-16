import 'package:flutter/material.dart';

import '../Constants/colors.dart';

class AboutGDSC extends StatelessWidget {
  const AboutGDSC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          color: CustomColors.primaryBlack,
          child: const Center(
            child: Text(
              'About GDSC Page',
              style: TextStyle(color: CustomColors.primaryWhite, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
