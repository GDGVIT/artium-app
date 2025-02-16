import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../Constants/colors.dart';

class Gallery extends StatelessWidget {
  const Gallery({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.primaryBlack,
      body: SingleChildScrollView(
        child: Container(
          color: CustomColors.primaryBlack,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              _buildGrid(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final List<String> imagePaths = [
      'images/galleryImage1.png',
      'images/galleryImage2.png',
      'images/galleryImage3.png',
      'images/galleryImage4.png',
      'images/galleryImage1.png'
    ];

    final List<String> titles = [
      'Sunset Bliss',
      'Mountain Peak',
      'Ocean Waves',
      'Forest Trail',
      'Sunset Bliss'
    ];

    final List<String> names = [
      'John Doe',
      'Jane Smith',
      'Emily Brown',
      'Michael Clark',
      'Sophia Davis'
    ];

    return MasonryGridView.count(
      crossAxisCount: 2,
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: imagePaths.length,
      itemBuilder: (context, index) {
        return GalleryContainer(
          imagePath: imagePaths[index % imagePaths.length],
          title: titles[index % titles.length],
          name: names[index % names.length], // Pass the name to the container
          extent: (index % 3 + 1) * 110,
        );
      },
    );
  }
}

class GalleryContainer extends StatefulWidget {
  final String imagePath;
  final String title;
  final String name;
  final double extent;

  const GalleryContainer({
    super.key,
    required this.imagePath,
    required this.title,
    required this.name,
    required this.extent,
  });

  @override
  State<GalleryContainer> createState() => _GalleryContainerState();
}

class _GalleryContainerState extends State<GalleryContainer> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.extent,
      decoration: BoxDecoration(
        color: CustomColors.tertiaryBlack,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              color: CustomColors.tertiaryBlack,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
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
                          widget.name.substring(0, 1),
                          style: const TextStyle(
                            color: CustomColors.primaryBlack,
                            fontFamily: "OutfitBold",
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8.0),
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: CustomColors.primaryWhite,
                          fontFamily: "OutfitMedium",
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isLiked = !isLiked;
                          });
                        },
                        child: Icon(
                          isLiked ? Icons.favorite : Icons.favorite_border,
                          color:
                              isLiked ? Colors.red : CustomColors.primaryWhite,
                          size: 12,
                        ),
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
