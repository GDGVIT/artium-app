import 'package:flutter/material.dart';

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
    Future.delayed(Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          widget.isLoggedIn ? '/home' : '/welcome',
        );
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
