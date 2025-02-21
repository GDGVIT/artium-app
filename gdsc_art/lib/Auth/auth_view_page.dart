import 'package:flutter/material.dart';
import 'package:artium/Auth/login_page.dart';
import 'package:artium/Auth/signup_page.dart';
import 'package:artium/Providers/user_notifier.dart';
import 'package:provider/provider.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
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
        .setUser(User(name: 'Guest', email: '', image: '', id: ''));
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
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: skipAuth,
            ),
          ),
        ],
      ),
    );
  }
}
