import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Providers/user_notifier.dart';
import 'package:provider/provider.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String? baseUrl = BaseUrl.baseUrl;
  bool isPressed = false;
  int? selectedIndex;
  int currentPageIndex = 0;

  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final userNotifier = Provider.of<UserNotifier>(context);
    final user = userNotifier.user;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 5.0),
                _buildUserDetails(
                    user ??
                        User(name: "Guest", email: "guest@gmail.com", id: ''),
                    context),
                const SizedBox(height: 10.0),
                _buildPageIndicators(),
                const SizedBox(height: 10.0),
                _buildPageView(),
              ],
            ),
          ),
          if (isPressed)
            AnimatedOpacity(
              duration: const Duration(milliseconds: 300),
              opacity: 0.7,
              child: Container(
                color: Colors.black,
              ),
            ),

          // Add the back button if an image is expanded
          if (selectedIndex != null)
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              left: MediaQuery.of(context).size.width * 0.05,
              child: _buildIOSBackButton(),
            ),

          if (selectedIndex != null)
            AnimatedPositioned(
              duration: const Duration(milliseconds: 300),
              top: isPressed ? MediaQuery.of(context).size.height * 0.15 : 0,
              left: isPressed ? MediaQuery.of(context).size.width * 0.15 : 0,
              right: isPressed ? MediaQuery.of(context).size.width * 0.15 : 0,
              bottom: isPressed ? MediaQuery.of(context).size.height * 0.35 : 0,
              child: _buildExpandedContainer(context, selectedIndex!),
            ),
        ],
      ),
    );
  }

  // Build the user's details section
  Widget _buildUserDetails(User user, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: CustomColors.primaryBlack,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                child: ClipOval(
                  child: user.image != null
                      ? Image.network(
                          baseUrl! + user.image!,
                          fit: BoxFit.fill,
                          width: 55,
                          height: 55,
                        )
                      : Image.asset(
                          'images/person2.png',
                          fit: BoxFit.fill,
                          width: 55,
                          height: 55,
                        ),
                ),
              ),
              const SizedBox(width: 16.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name,
                    style: const TextStyle(
                      color: CustomColors.secondaryCream,
                      fontSize: 19.0,
                      fontFamily: 'OutfitMedium',
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    user.email,
                    style: TextStyle(
                      fontSize: 13.0,
                      color: Colors.grey[600],
                      fontFamily: 'OutfitRegular',
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Spacer(),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.primaryCream,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              textStyle: const TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: Image.asset(
              'images/vector.png',
              width: 20,
              height: 20,
              color: CustomColors.primaryBlack,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageIndicators() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "Saved",
                    style: TextStyle(
                      color: currentPageIndex == 0
                          ? CustomColors.primaryCream
                          : Colors.grey,
                      fontSize: 19.0,
                      fontFamily: 'OutfitMedium',
                      decoration: currentPageIndex == 0
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _pageController.animateToPage(1,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  alignment: Alignment.center,
                  child: Text(
                    "Published",
                    style: TextStyle(
                      color: currentPageIndex == 1
                          ? CustomColors.primaryCream
                          : Colors.grey,
                      fontSize: 19.0,
                      fontFamily: 'OutfitMedium',
                      decoration: currentPageIndex == 1
                          ? TextDecoration.underline
                          : TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 2.0,
                color: currentPageIndex == 0
                    ? CustomColors.primaryCream
                    : Colors.transparent,
              ),
            ),
            Expanded(
              child: Container(
                height: 2.0,
                color: currentPageIndex == 1
                    ? CustomColors.primaryCream
                    : Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPageView() {
    return SizedBox(
      height: 500, // Adjust based on your needs
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: [
          _buildGrid(), // Saved content
          _buildGrid(), // Published content
        ],
      ),
    );
  }

  // Build the grid for gallery items
  Widget _buildGrid() {
    final List<String> imagePaths = [
      'images/galleryImage1.png',
      'images/galleryImage2.png',
      'images/galleryImage3.png',
      'images/galleryImage4.png',
      'images/galleryImage1.png',
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20.0),
          MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: imagePaths.length,
            itemBuilder: (context, index) {
              return _GalleryContainer(
                imagePath: imagePaths[index % imagePaths.length],
                title: 'Art Piece ${index + 1}',
                extent: (index % 3 + 1) * 110,
                isPressed: isPressed && selectedIndex == index,
                onTap: () => _onPress(index),
              );
            },
          ),
        ],
      ),
    );
  }

  void _onPress(int index) {
    setState(() {
      isPressed = true;
      selectedIndex = index;
    });
  }

  void _onRelease() {
    setState(() {
      isPressed = false;
      selectedIndex = null;
    });
  }

  Widget _buildExpandedContainer(BuildContext context, int index) {
    final List<String> imagePaths = [
      'images/galleryImage1.png',
      'images/galleryImage2.png',
      'images/galleryImage3.png',
      'images/galleryImage4.png',
      'images/galleryImage1.png',
    ];

    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: CustomColors.tertiaryBlack,
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 220,
              margin: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePaths[index]),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 8.0),
              color: CustomColors.tertiaryBlack,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.0,
                        ),
                        child: Text(
                          "Sample Title",
                          style: TextStyle(
                            color: CustomColors.secondaryCream,
                            fontFamily: "OutfitMedium",
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const Spacer(),
                      PopupMenuButton<String>(
                        color: const Color(0xFF5B5B5B),
                        icon: const Icon(
                          Icons.more_vert,
                          color: CustomColors.primaryCream,
                          size: 20,
                        ),
                        onSelected: (value) {
                          if (value == 'Publish') {
                            // Implement publish logic here
                          } else if (value == 'Delete') {
                            // Implement delete logic here
                          }
                        },
                        itemBuilder: (BuildContext context) {
                          return [
                            PopupMenuItem<String>(
                              value: 'Publish',
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
                                        color: CustomColors.primaryCream),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'Delete',
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
                                        color: CustomColors.primaryCream),
                                  ),
                                ],
                              ),
                            ),
                          ];
                        },
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

  Widget _buildIOSBackButton() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0), // Rounded rectangle border
        border: Border.all(
          color: CustomColors.primaryCream,
          width: 2.0,
        ),
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          color: CustomColors.primaryCream,
          size: 20,
        ),
        onPressed: _onRelease,
        splashColor: Colors.transparent,
      ),
    );
  }
}

// Custom container for gallery items
class _GalleryContainer extends StatelessWidget {
  final String imagePath;
  final String title;
  final double extent;
  final bool isPressed;
  final VoidCallback onTap;

  const _GalleryContainer({
    required this.imagePath,
    required this.title,
    required this.extent,
    required this.isPressed,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: extent,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: const Color(0x000d0b0a),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              child: Image.asset(
                imagePath,
                height: extent - 60,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4.0,
                    horizontal: 8.0,
                  ),
                  child: Text(
                    title,
                    style: const TextStyle(
                      color: CustomColors.secondaryCream,
                      fontFamily: "OutfitMedium",
                      fontSize: 13,
                    ),
                  ),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  color: const Color(0xFF5B5B5B),
                  icon: const Icon(
                    Icons.more_vert,
                    color: CustomColors.primaryCream,
                    size: 20,
                  ),
                  onSelected: (value) {
                    if (value == 'Publish') {
                      // Implement publish logic here
                    } else if (value == 'Delete') {
                      // Implement delete logic here
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem<String>(
                        value: 'Publish',
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
                              style:
                                  TextStyle(color: CustomColors.primaryCream),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'Delete',
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
                              style:
                                  TextStyle(color: CustomColors.primaryCream),
                            ),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
