import 'package:flutter/material.dart';

import '../Constants/Colors.dart';

class AboutGDSC extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
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
