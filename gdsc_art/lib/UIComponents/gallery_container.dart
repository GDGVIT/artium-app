import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:artium/Constants/colors.dart';
import 'package:artium/UIComponents/dynamic_aspect_ratio_image.dart';

class GalleryContainer extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String name;
  final int likes;
  final double aspectRatio;
  final bool showReviewStatus;
  final bool isReviewed;
  final bool isAccountPage;
  final Function()? onDelete;
  final Function()? onPublish;

  const GalleryContainer({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.name,
    required this.likes,
    this.aspectRatio = 1.0,
    this.showReviewStatus = false,
    this.isReviewed = false,
    this.isAccountPage = false,
    this.onDelete,
    this.onPublish,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xff363336),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DynamicAspectRatioImage(
                  imageUrl: imageUrl,
                  defaultAspectRatio: aspectRatio,
                  isGallery: !isAccountPage,
                ),
                Container(
                  padding: EdgeInsets.all(!isAccountPage ? 8.0 : 0),
                  color: Color(0xff363336),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: isAccountPage ? 8.0 : 0),
                              child: Text(
                                title,
                                style: const TextStyle(
                                  color: CustomColors.primaryCream,
                                  fontFamily: "OutfitBold",
                                  fontSize: 16,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          if (isAccountPage)
                            PopupMenuButton<String>(
                              color: const Color(0xFF5B5B5B),
                              icon: const Icon(
                                Icons.more_vert,
                                color: CustomColors.primaryWhite,
                                size: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              onSelected: (value) {
                                if (value == 'publish' && onPublish != null) {
                                  onPublish!();
                                } else if (value == 'delete' &&
                                    onDelete != null) {
                                  onDelete!();
                                }
                              },
                              itemBuilder: (BuildContext context) => [
                                if (!isReviewed)
                                  PopupMenuItem<String>(
                                    value: 'publish',
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          'images/popmenuIcon.png',
                                          width: 20,
                                          height: 20,
                                          color: CustomColors.primaryCream,
                                        ),
                                        const SizedBox(width: 8.0),
                                        const Text(
                                          'Publish',
                                          style: TextStyle(
                                            color: CustomColors.primaryCream,
                                            fontFamily: 'OutfitSemiBold',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'images/popmenuIcon2.png',
                                        width: 20,
                                        height: 20,
                                        color: CustomColors.primaryCream,
                                      ),
                                      const SizedBox(width: 8.0),
                                      const Text(
                                        'Delete',
                                        style: TextStyle(
                                          color: CustomColors.primaryCream,
                                          fontFamily: 'OutfitSemiBold',
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      if (!isAccountPage) ...[
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
                            if (!isAccountPage)
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
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isAccountPage && isReviewed)
            Positioned(
              top: 8,
              left: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: CustomColors.primaryCream,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Published',
                  style: TextStyle(
                    color: CustomColors.primaryBlack,
                    fontSize: 12,
                    fontFamily: 'OutfitMedium',
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
