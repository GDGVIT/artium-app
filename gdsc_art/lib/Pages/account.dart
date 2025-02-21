import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:gdsc_artwork/Constants/base_url.dart';
import 'package:gdsc_artwork/Model/gallery_model.dart';
import 'package:gdsc_artwork/Providers/user_data_provider.dart';
import 'package:gdsc_artwork/UIComponents/gallery_container.dart';
import 'package:gdsc_artwork/UIComponents/shimmer_gallery_item.dart';
import 'package:provider/provider.dart';

var baseUrl = BaseUrl.baseUrl;

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  int currentPageIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<UserDataProvider>(context, listen: false);
      await provider.getUserData();
      if (provider.userId != null) {
        await provider.fetchArts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserDataProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 5.0),
                _buildUserDetails(provider),
                const SizedBox(height: 10.0),
                _buildPageIndicators(),
                const SizedBox(height: 10.0),
                _buildPageView(provider),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserDetails(UserDataProvider provider) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: CustomColors.primaryBlack,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: ClipOval(
              child: provider.userImage != null
                  ? Image.network(
                      baseUrl! + provider.userImage!,
                      fit: BoxFit.cover,
                      width: 55,
                      height: 55,
                    )
                  : Image.asset(
                      'images/person2.png',
                      fit: BoxFit.cover,
                      width: 55,
                      height: 55,
                    ),
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.userName ?? 'Guest',
                  style: const TextStyle(
                    color: CustomColors.secondaryCream,
                    fontSize: 19.0,
                    fontFamily: 'OutfitMedium',
                  ),
                ),
                Text(
                  provider.userEmail ?? 'guest@gmail.com',
                  style: TextStyle(
                    fontSize: 13.0,
                    color: Colors.grey[600],
                    fontFamily: 'OutfitRegular',
                  ),
                ),
              ],
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
            _buildTabButton("Saved", 0),
            _buildTabButton("Published", 1),
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

  Widget _buildTabButton(String title, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: currentPageIndex == index
                  ? CustomColors.primaryCream
                  : Colors.grey,
              fontSize: 19.0,
              fontFamily: 'OutfitMedium',
              decoration: currentPageIndex == index
                  ? TextDecoration.underline
                  : TextDecoration.none,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPageView(UserDataProvider provider) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        children: [
          _buildArtsGrid(provider, false),
          _buildArtsGrid(provider, true),
        ],
      ),
    );
  }

  Widget _buildArtsGrid(UserDataProvider provider, bool isPublished) {
    if (provider.isLoading) {
      return _buildShimmerGrid();
    }

    if (provider.hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              provider.errorMessage ?? 'An error occurred',
              style: const TextStyle(color: CustomColors.primaryCream),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => provider.fetchArts(refresh: true),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final List<GalleryModel> filteredArts =
        provider.arts.where((art) => art.reviewed == isPublished).toList();

    if (filteredArts.isEmpty) {
      return Center(
        child: Text(
          isPublished ? 'No published arts yet' : 'No saved arts yet',
          style: const TextStyle(color: CustomColors.primaryCream),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => provider.fetchArts(refresh: true),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: MasonryGridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          itemCount: filteredArts.length,
          itemBuilder: (context, index) {
            final art = filteredArts[index];
            return GalleryContainer(
              imageUrl: baseUrl! + art.imageUrl,
              title: art.title,
              name: art.artist.name,
              likes: art.likes,
              aspectRatio: art.aspectRatio ?? 1.0,
            );
          },
        ),
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        itemCount: 6,
        itemBuilder: (context, index) => ShimmerGalleryItem(
          aspectRatio: index.isEven ? 0.8 : 1.2,
        ),
      ),
    );
  }
}
