import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isCentered;

  const CustomAppBar({super.key, required this.title, this.isCentered = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color(0xff141414),
        elevation: 0,
        centerTitle: isCentered,
        title: Text(
          title == 'Art Gallery' ? '' : title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontFamily: 'OutfitMedium',
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: CustomColors.primaryWhite),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        actions: [
          if (title == 'Art Gallery')
            Padding(
              padding: const EdgeInsets.only(right: 24.0),
              child: Row(
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
                ],
              ),
            )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
