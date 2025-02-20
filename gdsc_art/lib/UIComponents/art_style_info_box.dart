import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class ArtStyleInfoBox extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback onPressed;

  const ArtStyleInfoBox({
    super.key,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 32, right: 32, top: 32),
      padding:
          const EdgeInsets.only(left: 24.0, right: 24, top: 12, bottom: 24),
      decoration: BoxDecoration(
        color: CustomColors.secondaryBlack,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: CustomColors.primaryWhite,
              fontSize: 19.0,
              fontFamily: 'OutfitMedium',
            ),
          ),
          const SizedBox(height: 4.0),
          Container(
            height: 1.0,
            color: CustomColors.primaryWhite.withOpacity(0.5),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
          ),
          const SizedBox(height: 4.0),
          Text(
            textAlign: TextAlign.left,
            description,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
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
            child: const Text(
              'Use this style',
              style: TextStyle(
                fontSize: 16,
                fontFamily: 'OutfitSemiBold',
                color: CustomColors.primaryWhite,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
