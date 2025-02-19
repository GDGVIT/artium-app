import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Constants/Colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool isCentered;

  const CustomAppBar({super.key, required this.title, this.isCentered = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.primaryBlack,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Color(0xff141414),
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
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
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
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
