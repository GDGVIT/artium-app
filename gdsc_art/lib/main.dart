import 'package:flutter/material.dart' hide CarouselController;
import 'package:gdsc_artwork/Auth/auth_view_page.dart';
import 'package:gdsc_artwork/Home.dart';
import 'package:gdsc_artwork/Pages/OnBoarding/on_boarding.dart';
import 'package:gdsc_artwork/Pages/OnBoarding/welcome.dart';
import 'package:gdsc_artwork/Pages/account.dart';
import 'package:gdsc_artwork/Providers/gallery_provider.dart';
import 'package:gdsc_artwork/Providers/login_and_signup_provider.dart';
import 'package:gdsc_artwork/Providers/theme_provider.dart';
import 'package:gdsc_artwork/Providers/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');
  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserNotifier()),
        ChangeNotifierProvider(create: (_) => LoginAndSignupProvider()),
        ChangeNotifierProvider(create: (_) => GalleryProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: MaterialApp(
        title: 'Art Gallery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Outfit',
        ),
        initialRoute: isLoggedIn ? '/welcome' : '/auth',
        routes: {
          '/auth': (context) => const AuthPage(),
          '/home': (context) => const Home(),
          '/account': (context) => const Account(),
          '/welcome': (context) => const Welcome(),
          '/onboarding': (context) => const OnBoarding(),
        },
        onGenerateRoute: (settings) {
          if (!isLoggedIn && settings.name != '/auth') {
            return MaterialPageRoute(
              builder: (context) => const AuthPage(),
            );
          }
          return null;
        },
      ),
    );
  }
}
