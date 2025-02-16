import 'package:flutter/material.dart' hide CarouselController;
import 'package:gdsc_artwork/Auth/auth_view_page.dart';
import 'package:gdsc_artwork/Home.dart';
import 'package:gdsc_artwork/Pages/account.dart';
import 'package:gdsc_artwork/ViewModel/login_and_signup_provider.dart';
import 'package:gdsc_artwork/ViewModel/user_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserNotifier()),
        ChangeNotifierProvider(create: (_) => LoginAndSignupProvider()),
      ],
      
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/auth',
        routes: {
          '/auth': (context) => const AuthPage(),
          '/home': (context) => Home(),
          '/account': (context) => const Account(),
        },
      ),
    );
  }
}
