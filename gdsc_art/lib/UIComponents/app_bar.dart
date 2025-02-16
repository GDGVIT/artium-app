import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isCentered;

  CustomAppBar({required this.title, this.isCentered = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: CustomColors.primaryBlack,
      elevation: 0,
      centerTitle: isCentered,
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontFamily: 'OutfitMedium',
        ),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: const Icon(Icons.menu, color: CustomColors.primaryWhite),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
