import 'package:flutter/material.dart';
import 'package:gdsc_artwork/Auth/LoginPage.dart';
import 'package:gdsc_artwork/Auth/SignupPage.dart';
import 'package:gdsc_artwork/ViewModel/user_notifier.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool showLogin = true;

  void toggleView() {
    setState(() {
      showLogin = !showLogin;
    });
  }

  void skipAuth() {
    Provider.of<UserNotifier>(context, listen: false)
        .setUser(User(name: 'Guest', email: '', profileImage: ''));
    Navigator.pushReplacementNamed(context, '/home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          showLogin
              ? LoginPage(toggleView: toggleView)
              : SignupPage(toggleView: toggleView),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: Icon(Icons.close, color: Colors.white),
              onPressed: skipAuth,
            ),
          ),
        ],
      ),
    );
  }
}
