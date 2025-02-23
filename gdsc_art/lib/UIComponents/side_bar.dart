import 'package:artium/Providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:artium/Constants/base_url.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../Constants/Colors.dart';
import 'package:artium/Providers/user_notifier.dart';

String? baseUrl = BaseUrl.baseUrl;

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final userNotifier = Provider.of<UserNotifier>(context);
    final user = userNotifier.user;

    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.6,
        child: Container(
          color: CustomColors.primaryBlack,
          child: Stack(
            children: [
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  'images/drawer_top_right.png',
                  height: 350,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Image.asset('images/drawer_bottom.png'),
              ),
              Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.12,
                  ),
                  user?.name != "Guest"
                      ? _buildProfileHeader(user)
                      : Container(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
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
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Divider(
                      color: CustomColors.primaryCream.withValues(alpha: 0.25),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child:
                        _buildSignOutOrLoginTile(context, userNotifier, user),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ],
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
    final profileImageUrl = user?.image;

    return FutureBuilder<bool>(
      future: profileImageUrl != null
          ? _isValidImageUrl('$baseUrl$profileImageUrl')
          : Future.value(false),
      builder: (context, snapshot) {
        ImageProvider profileImage;
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data == true) {
          profileImage = NetworkImage('$baseUrl$profileImageUrl');
        } else {
          profileImage = const AssetImage('images/userprofile.png');
        }

        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: profileImage,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: RichText(
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    children: [
                      const TextSpan(
                        text: 'Welcome,\n',
                        style: TextStyle(
                          color: CustomColors.primaryCream,
                          fontSize: 24,
                          fontFamily: 'OutfitRegular',
                        ),
                      ),
                      TextSpan(
                        text: '${user?.name ?? 'Guest'}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'OutfitRegular',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
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
          fontFamily: "OutfitRegular",
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
            fontFamily: "OutfitRegular",
            color: CustomColors.primaryCream,
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
          'Sign out',
          style: TextStyle(
            fontSize: 20,
            fontFamily: "OutfitRegular",
            color: CustomColors.primaryCream,
          ),
        ),
        onTap: () async {
          await Provider.of<UserDataProvider>(context, listen: false)
              .clearUserData();
          if (!context.mounted) return;
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
