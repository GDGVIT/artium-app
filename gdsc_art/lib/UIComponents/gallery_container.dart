
import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/colors.dart';
import 'package:gdsc_artwork/UIComponents/dynamic_aspect_ratio_image.dart';

class GalleryContainer extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String name;
  final int likes;
  final double aspectRatio;

  const GalleryContainer({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.name,
    required this.likes,
    this.aspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.tertiaryBlack,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DynamicAspectRatioImage(
              imageUrl: imageUrl,
              defaultAspectRatio: aspectRatio,
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.primaryCream,
                      fontFamily: "OutfitBold",
                      fontSize: 11,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4.0),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10.0,
                        backgroundColor: CustomColors.primaryWhite,
                        child: Text(
                          name[0].toUpperCase(),
                          style: const TextStyle(
                            color: CustomColors.primaryBlack,
                            fontFamily: "OutfitBold",
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(
                            color: CustomColors.primaryWhite,
                            fontFamily: "OutfitMedium",
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.favorite,
                            color: Colors.red,
                            size: 12,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$likes',
                            style: const TextStyle(
                              color: CustomColors.primaryWhite,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
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
