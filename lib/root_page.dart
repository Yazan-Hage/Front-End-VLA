import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'view/intro/intro_screens.dart';
import 'view/splash/splash_screen.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  Future<bool> _loadSeenIntro() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('seen_intro') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _loadSeenIntro(),
      builder: (ctx, snap) {
        if (!snap.hasData) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        final seenIntro = snap.data!;
        // If we’ve never seen the intro, show it first.
        return seenIntro ? const SplashScreen() : const IntroScreens();
      },
    );
  }
}
