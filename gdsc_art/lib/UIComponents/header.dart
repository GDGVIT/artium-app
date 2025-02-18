import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gdsc_artwork/Constants/colors.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
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
        Spacer(),
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
    );
  }
}
