import 'package:artium/Pages/splash.dart';
import 'package:flutter/material.dart' hide CarouselController;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:artium/Auth/auth_view_page.dart';
import 'package:artium/Providers/create_art_provider.dart';
import 'package:artium/Providers/user_data_provider.dart';
import 'package:artium/home.dart';
import 'package:artium/Pages/OnBoarding/on_boarding.dart';
import 'package:artium/Pages/OnBoarding/welcome.dart';
import 'package:artium/Pages/account.dart';
import 'package:artium/Providers/gallery_provider.dart';
import 'package:artium/Providers/login_and_signup_provider.dart';
import 'package:artium/Providers/theme_provider.dart';
import 'package:artium/Providers/user_notifier.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
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
        ChangeNotifierProvider(
          create: (_) => GalleryProvider(),
          lazy: true,
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
          lazy: true,
        ),
        ChangeNotifierProvider(create: (_) => CreateArtProvider()),
        ChangeNotifierProvider(
          create: (_) => UserDataProvider(),
          lazy: true,
        )
      ],
      child: MaterialApp(
        title: 'Art Gallery',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Outfit',
        ),
        initialRoute: isLoggedIn ? '/home' : '/welcome',
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
