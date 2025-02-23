import 'package:artium/Providers/user_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SplashScreen extends StatefulWidget {
  final bool isLoggedIn;
  const SplashScreen({super.key, required this.isLoggedIn});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    Future.delayed(const Duration(seconds: 2), () async {
      final prefs = await SharedPreferences.getInstance();
      final installed = prefs.getBool('installed');
      if (installed == null) {
        prefs.setBool('installed', true);
        if (!mounted) return;
        if (widget.isLoggedIn) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      } else {
        if (!mounted) return;
        final provider = Provider.of<UserDataProvider>(context, listen: false);
        await provider.getUserData(context);
        if (widget.isLoggedIn) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/home');
        } else if (installed) {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/auth');
        } else {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/welcome');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1B191B),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/app_icon.png',
              width: 48,
              height: 48,
            ),
            Text(
              'Artium',
              style: TextStyle(
                fontSize: 48,
                fontFamily: 'OutfitExtraLight',
                color: Colors.white,
              ),
            )
          ],
        ),
      ),
    );
  }
}
