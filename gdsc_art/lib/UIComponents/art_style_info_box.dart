import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class ArtStyleInfoBox extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  ArtStyleInfoBox({
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 2),
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: CustomColors.secondaryBlack,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: CustomColors.secondaryCream,
              fontSize: 19.0,
              fontFamily: 'OutfitMedium',
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            height: 2.0,
            color: CustomColors.primaryBrown,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          Text(
            textAlign: TextAlign.left,
            description,
            style: const TextStyle(
              color: CustomColors.primaryWhite,
              fontSize: 13.0,
              fontFamily: 'OutfitRegular',
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryBrown,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
              textStyle: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('Use this style'),
          ),
        ],
      ),
    );
  }
}
