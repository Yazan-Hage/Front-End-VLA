import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/name_of_pages.dart';
import '../controller/auth_controller.dart';
import '../root_page.dart';
import 'home/home_screen.dart';
import 'intro/intro_screens.dart';
import 'login/login_screen.dart';
import 'register/register_screen01.dart';
import 'splash/splash_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const RootPage(),
      routes: {
        Screens.introScreen    : (_) => const IntroScreens(),
        Screens.logInScreen    : (_) => const LoginPage(),
        Screens.registerScreen : (_) => RegisterStep1Page(),
        Screens.homeScreen     : (_) => HomeScreen(),
        Screens.splashScreen   : (_) => const SplashScreen(),
      },
    );
  }
}