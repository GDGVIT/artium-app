import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Constants/Colors.dart';
import 'package:gdsc_artwork/ViewModel/user_notifier.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  Sidebar({
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final userNotifier = Provider.of<UserNotifier>(context);
    final user = userNotifier.user;

    return SafeArea(
      child: SizedBox(
        child: Drawer(
          width: MediaQuery.of(context).size.width * 0.6,
          child: Container(
            color: CustomColors.primaryBlack,
            child: Column(
              children: [
                user?.name != "Guest" ? _buildProfileHeader(user) : Container(),
                user?.name != "Guest"
                    ? const Divider(
                        color: CustomColors.primaryBrown,
                        thickness: 2,
                      )
                    : Container(),
                Expanded(
                  child: ListView(
                    children: [
                      _createDrawerItem(
                          context,
                          0,
                          'Create',
                          'images/createIcon.png',
                          selectedIndex,
                          onItemSelected,
                          user),
                      _createDrawerItem(
                          context,
                          1,
                          'Themes',
                          'images/themeoftheday.png',
                          selectedIndex,
                          onItemSelected,
                          user),
                      _createDrawerItem(
                          context,
                          2,
                          'About',
                          'images/aboutgdsc.png',
                          selectedIndex,
                          onItemSelected,
                          user),
                      _createDrawerItem(
                          context,
                          3,
                          'View Gallery',
                          'images/gallery.png',
                          selectedIndex,
                          onItemSelected,
                          user),
                      _createDrawerItem(
                          context,
                          4,
                          'MyAccount',
                          'images/account.png',
                          selectedIndex,
                          onItemSelected,
                          user),
                    ],
                  ),
                ),
                const Divider(
                  color: CustomColors.primaryBrown,
                  thickness: 2,
                ),
                _buildSignOutOrLoginTile(context, userNotifier, user),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> _isValidImageUrl(String url) async {
    try {
      final response = await http.head(Uri.parse(url));
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Widget _buildProfileHeader(User? user) {
    final profileImageUrl = user?.profileImage;

    return FutureBuilder<bool>(
      future: profileImageUrl != null
          ? _isValidImageUrl('http://localhost:8000$profileImageUrl')
          : Future.value(false),
      builder: (context, snapshot) {
        ImageProvider profileImage;
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == true) {
          profileImage = NetworkImage('http://localhost:8000$profileImageUrl');
        } else {
          profileImage = AssetImage('images/userprofile.png');
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: profileImage,
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  user?.name == 'Guest'
                      ? const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            color: CustomColors.secondaryBrown,
                            fontFamily: "OutfitMedium",
                            fontSize: 20,
                          ),
                        )
                      : Container(),
                  Text(
                    user?.name ?? 'Guest',
                    style: const TextStyle(
                      color: CustomColors.secondaryBrown,
                      fontFamily: "OutfitMedium",
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _createDrawerItem(
      BuildContext context,
      int index,
      String title,
      String iconPath,
      int selectedIndex,
      Function(int) onItemSelected,
      User? user) {
    return ListTile(
      leading: Image.asset(iconPath, width: 25, height: 25),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontFamily: "OutfitMedium",
          color: CustomColors.primaryWhite,
          decoration: index == selectedIndex
              ? TextDecoration.underline
              : TextDecoration.none,
        ),
      ),
      onTap: () {
        Navigator.of(context).pop();
        onItemSelected(index);
      },
    );
  }

  Widget _buildSignOutOrLoginTile(
      BuildContext context, UserNotifier userNotifier, User? user) {
    if (user?.name == 'Guest') {
      return ListTile(
        leading: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset('images/person.png'),
        ),
        title: const Text(
          'Login',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "OutfitMedium",
            color: CustomColors.primaryWhite,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.pushReplacementNamed(context, '/auth');
        },
      );
    } else {
      return ListTile(
        leading: SizedBox(
          width: 20,
          height: 20,
          child: Image.asset('images/logout.png'),
        ),
        title: const Text(
          'Signout',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "OutfitMedium",
            color: CustomColors.primaryWhite,
          ),
        ),
        onTap: () {
          Navigator.of(context).pop();
          _signOut(context, userNotifier);
        },
      );
    }
  }

  void _signOut(BuildContext context, UserNotifier userNotifier) {
    userNotifier.clearUser();
    Navigator.pushReplacementNamed(context, '/auth');
  }
}
